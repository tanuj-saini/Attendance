const mongoose = require("mongoose");

const UserModule = mongoose.Schema({
  name: {
    require: true,
    type: String,
  },
  emailAddress: {
    require: true,
    type: String,
  },

  rollNumber: {
    require: true,
    type: String,
  },
  password: {
    require: true,
    type: String,
  },
  imageUrl: {
    require: true,
    type: String,
  },
});
const userModule = mongoose.model("userModule", UserModule);
module.exports = { userModule, UserModule };
