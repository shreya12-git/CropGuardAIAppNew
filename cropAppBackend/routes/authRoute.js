const express = require("express");
const router = express.Router();
const { signup, signin, logout, userProfile, sendotp,verifyOtpAndCreateUser } = require("../controllers/authController");
const { isAuthenticated } = require("../middleware/auth");

// Auth Routes
router.post("/signup", signup);
router.post("/createuser",verifyOtpAndCreateUser);
router.post("/signin", signin);
router.post("/sendotp", sendotp);
router.get("/logout", logout);

// Protected Route: Requires Authentication
router.get("/me", isAuthenticated, userProfile);

module.exports = router;
