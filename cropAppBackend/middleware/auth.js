const ErrorResponse = require('../utils/errorResponse');
const jwt = require('jsonwebtoken');
const User = require("../models/userModel");

// check is user is authenticated
exports.isAuthenticated = async (req, res, next) => {
    const { token } = req.cookies;
    // Make sure token exists
    if (!token) {
        return next(new ErrorResponse('Login For the following services', 401));
    }

    try {
        // Verify token
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        req.user = await User.findById(decoded.id);
        next();

    } catch (error) {
        return next(new ErrorResponse('Not authorized to access this route', 401));
    }
}