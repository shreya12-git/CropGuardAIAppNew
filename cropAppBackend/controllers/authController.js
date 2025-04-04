const User = require('../models/userModel');
const OTP = require("../models/OTP");
const ErrorResponse = require('../utils/errorResponse');
const otpGenerator = require("otp-generator");
const bcrypt = require("bcryptjs");
const { log } = require('console');

// SIGNUP - Initial Step
exports.signup = async (req, res, next) => {
    console.log("Signup route hit", req.body); 
   
    try {
        const { email, password, confirmPassword } = req.body;
        console.log("Extracted Email:", email);

        // Validate passwords
        if (password !== confirmPassword) {
            return res.status(400).json({
                success: false,
                message: "Passwords do not match",
            });
        }

        // Check if user already exists
        const userExist = await User.findOne({ email });
        if (userExist) {
            return res.status(400).json({
                success: false,
                message: "User already exists",
            });
        }

        // Hash password
        const hashedPassword = await bcrypt.hash(password, 10);

        // Store user temporarily without saving
        const user = new User({ email, password: hashedPassword , first:true });

        res.status(200).json({
            success: true,
            message: "User details stored. Proceed to OTP verification",
            user: { email },
        });
    } catch (error) {
        next(error);
    }
};

// SIGNIN
exports.signin = async (req, res, next) => {
    try {
        const { email, password } = req.body;

        // Validate input
        if (!email || !password) {
            return next(new ErrorResponse("Please provide both email and password", 400));
        }

        // Find user
        const user = await User.findOne({ email });
        if (!user) {
            return res.status(404).json({
                success: false,
                message: "User not found",
            });
        }

        // Check password
        const isMatched = await user.comparePassword(password);
        if (!isMatched) {
            return res.status(400).json({
                success: false,
                message: "Invalid password",
            });
        }

        // Log successful sign-in
        console.log(`User signed in: ${email}`);

        sendTokenResponse(user, 200, res);
        
    } catch (error) {
        next(error);
    }
};


// SEND OTP
exports.sendotp = async (req, res) => {
    try {
        const { email,password,confirmPassword } = req.body;

        // Check if user already exists
        const userExist = await User.findOne({ email });
        if (userExist) {
            return res.status(400).json({
                success: false,
                message: "User already exists",
            });
        }
        if (password !== confirmPassword) {
            return res.status(400).json({
                success: false,
                message: "Passwords do not match",
            });
        }
        
        // Generate OTP
        let otp = otpGenerator.generate(6, { upperCaseAlphabets: false, lowerCaseAlphabets: false, specialChars: false });

        // Ensure unique OTP
        let existingOTP = await OTP.findOne({ otp });
        while (existingOTP) {
            otp = otpGenerator.generate(6, { upperCaseAlphabets: false, lowerCaseAlphabets: false, specialChars: false });
            existingOTP = await OTP.findOne({ otp });
        }

        // Store OTP
        await OTP.create({ email, otp });

        res.status(200).json({
            success: true,
            message: "OTP sent successfully",
            otp, // Remove this in production
        });
    } catch (error) {
        console.error(error.message);
        res.status(500).json({ success: false, error: error.message });
    }
};

// VERIFY OTP AND CREATE USER
exports.verifyOtpAndCreateUser = async (req, res, next) => {
    try {
        const { email, otp, password } = req.body;

        console.log("=== Incoming Request ===");
        console.log("Received Email:", email);
        console.log("Received OTP:", otp);
        console.log("Received Password:", password);
        console.log("Type of Received OTP:", typeof otp);

        // Fetch the latest OTP from database
        const response = await OTP.find({ email }).sort({ createdAt: -1 }).limit(1);
        console.log("Fetched OTP from DB:", response);

        if (response.length === 0) {
            console.log("No OTP found for this email.");
            return res.status(400).json({
                success: false,
                message: "Invalid OTP",
            });
        }

        console.log("Stored OTP in DB:", response[0].otp);
        console.log("Type of Stored OTP:", typeof response[0].otp);

        // Ensure both OTPs are compared as strings
        if (otp.toString().trim() !== response[0].otp.toString().trim()) {
            console.log("OTP Mismatch! Verification Failed.");
            return res.status(400).json({
                success: false,
                message: "Invalid OTP",
            });
        }

        console.log("OTP Matched! Proceeding to User Creation...");

        // Fetch user details to check if the user already exists
        const user = await User.findOne({ email });
        if (user) {
            console.log("User already exists:", user.email);
            return res.status(400).json({ success: false, message: "User already exists" });
        }
        first = true;
        // Create new user
        const newUser = await User.create({ email, password, first});
        console.log("New User Created:", newUser);

        sendTokenResponse(newUser, 201, res);
    } catch (error) {
        console.error("Error in OTP verification:", error);
        next(error);
    }
};


// LOGOUT
exports.logout = (req, res, next) => {
    res.clearCookie('token');
    res.status(200).json({
        success: true,
        message: "Logged out successfully",
    });
};

// GET USER PROFILE
exports.userProfile = async (req, res, next) => {
    try {
        const user = await User.findById(req.user.id).select('-password');
        res.status(200).json({
            success: true,
            user,
        });
    } catch (error) {
        next(error);
    }
};

// GENERATE TOKEN
const sendTokenResponse = async (user, codeStatus, res) => {
    const token = await user.getJwtToken();
    res.status(codeStatus).cookie('token', token, { maxAge: 60 * 60 * 1000, httpOnly: true }).json({
        success: true,
        token,
        user
    });
};


exports.updateprofile = async (req, res) => {
    try {
        const { email, full_name, DOB, city, state, pincode } = req.body;
        first = false;
        const updatedProfile = await User.findOneAndUpdate(
            { email: email }, // Find user by email
            { full_name, DOB, city, state, pincode ,first}, // Update fields
            { new: true } // Return the updated document
        );

        if (!updatedProfile) {
            return res.status(404).json({ success: false, message: "User not found" });
        }

        return res.status(200).json({
            success: true,
            updatedProfile
        });
    } catch (error) {
        return res.status(500).json({ success: false, message: "Internal server error", error: error.message });
    }
};

exports.get_data = async (req, res) => {
    const { email } = req.params;  // Extract email from request parameters
    const userDetails = await User.findOne({ email });

    return res.status(200).json({
        success: true,
        updatedProfile: userDetails
    });
};
