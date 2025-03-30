const express = require("express");
const app = express();
const morgan = require("morgan");
const bodyParser = require("body-parser");
const cors = require("cors");
const path = require("path");


// const errorHandler = require("./middleware/error");
const connectDB = require("./config/database");
// Load environment variables
require("dotenv").config();


// Import routes
const authRoutes = require("./routes/authRoute");
const cookieParser=require("cookie-parser");
const errorHandler=require("./middleware/error");

// Database Connection (Ensure it runs before the server starts)
connectDB();

// Middleware
if (process.env.NODE_ENV === 'development') {
  app.use(morgan('dev'))
}
app.use(bodyParser.json({ limit: "5mb" }));
app.use(bodyParser.urlencoded({
  limit: "5mb",
  extended: true
}));
app.use(cookieParser());
app.use(cors({ origin: '*' })); 



// Routes Middleware
app.use("/api", authRoutes);
__dirname = path.resolve()

// Serve static files in production
if (process.env.NODE_ENV === 'production') {
  app.use(express.static(path.join(__dirname, '/frontend/build')))

  app.get('*', (req, res) =>
    res.sendFile(path.resolve(__dirname, 'frontend', 'build', 'index.html'))
  )
} else {
  app.get('/', (req, res) => {
    res.send('API is running....')
  })
}

// Error Handling Middleware
app.use(errorHandler);



// app.get("/", (req, res) => {
//     res.send("MongoDB Connection Successful");
// });
// Start Server
const port = process.env.PORT || 8000;
app.listen(port, () => {
  console.log(`🚀 Server running on port ${port}`);
});
