require("dotenv").config();

const express = require("express");
const multer = require("multer");
const app = express();
const upload = multer ({ 
    storage: multer.memoryStorage() 
});
const path = require("path");
const fs = require("fs");
const { listBuckets,
        uploadFileToS3,
        getFileFromS3,
 } = require("./s3");
const { MongoClient } = require("mongodb");

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

const PORT = process.env.PORT || 3000;
const DATABASE = process.env.DATABASE;
if (!process.env.MONGO_URL) {
    throw new Error("MONGO_URL is missing from the .env file");
}
const client = new MongoClient(process.env.MONGO_URL);

let db;

async function start() {
    try {
        await client.connect();

        db = client.db(DATABASE);

        console.log("✅ Connected to MongoDB");

        await listBuckets();

        await uploadFileToS3("profile-images", 
            path.join(__dirname, "images/image1.jpg"), 
            "image1.jpg"
        );

        app.listen(PORT, () => {
            console.log(`🚀 Server running on port ${PORT}`);
        });

    } catch (err) {
        console.error(err);
        process.exit(1);
    }
}

start();

app.get("/", (req, res) => {
    res.sendFile(path.join(__dirname, "index.html"));
});

app.get("/profile-image", async (req, res)=> {
    
    try {
        const response = await getFileFromS3("profile-images", "image1.jpg");

        res.setHeader("Content-Type", response.ContentType);

        response.Body.pipe(res);

    } catch (err) {
    console.error(err);
    res.status(500).send(err.message);
}
    });

  app.post("/update-profile", upload.single("profileImage"), async (req, res) => {

    try {

        if (req.file) {
            await uploadFileToS3(
                "profile-images",
                req.file.buffer,
                "image1.jpg"
            );
        }

        const user = {
            userid: 1,
            name: req.body.name,
            email: req.body.email,
            interests: req.body.interests
        };

        await db.collection("users").updateOne(
            { userid: 1 },
            { $set: user },
            { upsert: true }
        );

        res.json(user);

    } catch (err) {

        console.error(err);

        res.status(500).json({
            message: "Failed to update profile"
        });

    }

});

app.get("/get-profile", async (req, res) => {

    try {

        const user = await db.collection("users").findOne({
            userid: 1
        });

        res.json(user || {});

    } catch (err) {

        console.error("MongoDB connection failed:", err);

        res.status(500).json({
            message: "Database error"
        });

    }

});