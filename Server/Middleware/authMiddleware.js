const jwt = require("jsonwebtoken");
const auth = async (req, res, next) => {
  try {
    const token = req.header("x-auth-token-w");
    if (!token) {
      return res.status(401).json({ msg: "No Auth taken" });
    }
    const verified = jwt.verify(token, "passwordKey");
    if (!verified) {
      return res.status(401).json({ msg: "token invalid" });
    }
    req.user = verified.id;
    req.token = token;
    next();
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};
module.exports = auth;
