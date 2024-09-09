const express = require("express");
const mongoose = require("mongoose");
const http = require("http");
const UserRouter = require("./routes/UserRoutes");

const mongooseUrl =
  "mongodb+srv://medeaszzz:attendence123@cluster0.dsrzu.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0";

const PORT = process.env.PORT || 3001;
const app = express();
const server = http.createServer(app);

app.use(express.json());
app.use(UserRouter);
// Connect to MongoDB
mongoose
  .connect(mongooseUrl)
  .then(() => {
    console.log("Connection Successful in mongoose");
  })
  .catch((e) => {
    console.log(e);
  });
// Start the server
server.listen(PORT, "0.0.0.0", () => {
  console.log(`Server started on port ${PORT}`);
});
