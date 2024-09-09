const express = require("express");
const jwt = require("jsonwebtoken");

const { userModule } = require("../Modules/UserModel");
const auth = require("../Middleware/authMiddleware");
const UserRouter = express.Router();
const bcrypt = require("bcryptjs"); // Import bcryptjs
const UserModelSendData = require("../Modules/UserSendData");

UserRouter.post("/user/profile", async (req, res) => {
  try {
    const { name, emailAddress, rollNumber, password, imageUrl } = req.body;

    let existingUser = await userModule.findOne({ emailAddress });

    if (existingUser) {
      return res
        .status(400)
        .json({ msg: "User already exists with this Email" });
    }

    // Hash the password before saving
    // Generate a salt
    const hashedPassword = await bcrypt.hash(password, 8); // Hash the password

    const newUser = new userModule({
      name,
      emailAddress,
      rollNumber,
      password: hashedPassword, // Save the hashed password
      imageUrl,
    });

    const savedUser = await newUser.save();
    const token = jwt.sign({ id: savedUser._id }, "passwordKey");

    // Sending token and user data separately
    res.json({
      token: token,
      user: {
        name: savedUser.name,
        emailAddress: savedUser.emailAddress,
        rollNumber: savedUser.rollNumber,
        imageUrl: savedUser.imageUrl,
      },
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

UserRouter.post("/tokenIsValid", async (req, res) => {
  try {
    const token = req.header("x-auth-token-w");
    if (!token) {
      return res.json(false);
    }
    const verified = jwt.verify(token, "passwordKey");
    if (!verified) {
      return res.json(false);
    }
    const user = await userModule.findById(verified.id);
    if (!user) {
      return res.json(false);
    }
    res.json(true);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});
UserRouter.get("/", auth, async (req, res) => {
  const savedUser = await userModule.findById(req.user);
  //by using auth middleware

  res.json({
    token: req.token,
    user: {
      name: savedUser.name,
      emailAddress: savedUser.emailAddress,
      rollNumber: savedUser.rollNumber,
      imageUrl: savedUser.imageUrl,
    },
  });
});
UserRouter.post("/api/signin", async (req, res) => {
  try {
    const { emailAddress, password } = req.body;

    // Use correct field for user lookup (emailAddress)
    const savedUser = await userModule.findOne({ emailAddress });
    if (!savedUser) {
      return res
        .status(400)
        .json({ msg: "User with this email does not exist!" });
    }

    // Compare plain password with hashed password
    const isMatch = await bcrypt.compare(password, savedUser.password);
    if (!isMatch) {
      return res.status(400).json({ msg: "Incorrect password." });
    }

    // Generate token using savedUser's id
    const token = jwt.sign({ id: savedUser._id }, "passwordKey");

    // Return token and user details
    res.json({
      token: token,
      user: {
        name: savedUser.name,
        emailAddress: savedUser.emailAddress,
        rollNumber: savedUser.rollNumber,
        imageUrl: savedUser.imageUrl,
      },
    });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});
UserRouter.post("/sendData", auth, async (req, res) => {
  try {
    const userC = await userModule.findById(req.user);
    if (!userC) {
      return res.status(400).json({ msg: "Invalid Token" });
    }

    const {
      name,
      rollNumber,
      location,
      wifiNetworks,
      imageUrl,
      audioUrl,
      deviceInfo,
    } = req.body;

    // Create a new user instance
    const user = new UserModelSendData({
      name,
      rollNumber,
      location,
      wifiNetworks,
      imageUrl,
      audioUrl,
      deviceInfo,
      createdAt: new Date(),
    });

    // Save the user to the database
    const savedUser = await user.save();

    // Respond with the saved user
    res.status(201).json();
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = UserRouter;
