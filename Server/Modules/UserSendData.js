const mongoose = require("mongoose");

const LocationSchema = new mongoose.Schema({
  latitude: {
    type: Number,
    required: false,
  },
  longitude: {
    type: Number,
    required: false,
  },
});

const WifiNetworkSchema = new mongoose.Schema({
  ssid: {
    type: String,
    required: false,
  },
  strength: {
    type: Number,
    required: false,
  },
});

const UserSchema = new mongoose.Schema({
  name: {
    type: String,
    required: false,
  },
  rollNumber: {
    type: String,
    required: false,
  },
  location: {
    type: LocationSchema,
    required: false,
  },
  wifiNetworks: {
    type: [WifiNetworkSchema],
    required: false,
  },
  imageUrl: {
    type: String,
    required: false,
  },
  audioUrl: {
    type: String,
    required: false,
  },
  deviceInfo: {
    type: String,
    required: false,
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
});

const UserModelSendData = mongoose.model("UserModelSendData", UserSchema);

module.exports = UserModelSendData;
