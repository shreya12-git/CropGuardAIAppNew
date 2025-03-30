const express = require("express");
const router = express.Router();
const { signup, signin, logout, sendotp,verifyOtpAndCreateUser, updateprofile, get_data } = require("../controllers/authController");

// Auth Routes
router.post("/signup", signup);
router.post("/createuser",verifyOtpAndCreateUser);
router.post("/signin", signin);
router.post("/sendotp", sendotp);
router.get("/logout", logout);

// Protected Route: Requires Authentication
router.get("/me/:email", get_data);
router.post("/update",updateprofile)
module.exports = router;
