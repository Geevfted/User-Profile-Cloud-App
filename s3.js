const {
  S3Client,
  ListBucketsCommand,
  PutObjectCommand,
  GetObjectCommand,
} = require("@aws-sdk/client-s3");

const fs = require("fs");

const s3 = new S3Client({
  region: process.env.AWS_REGION,
});

async function listBuckets() {
  try {
    const command = new ListBucketsCommand({});
    const response = await s3.send(command);

    console.log("========== S3 BUCKETS ==========");

    if (response.Buckets.length === 0) {
      console.log("No buckets found.");
    } else {
      response.Buckets.forEach((bucket) => {
        console.log(`- ${bucket.Name}`);
      });
    }

    console.log("===============================");
  } catch (err) {
    console.error("Failed to connect to S3");
    console.error(err);
  }
}

  async function uploadFileToS3(bucketName, filePath, key) {
    const fileContent = Buffer.isBuffer(filePath)
     ? filePath 
     : fs.readFileSync(filePath);

    const command = new PutObjectCommand({
      Bucket: bucketName,
      Key: key,
      Body: fileContent,
    });
    
    await s3.send(command);

        console.log("✅ Profile image uploaded to S3");

  }

    async function getFileFromS3(bucketName, key, downloadPath) {
    const command = new GetObjectCommand({
      Bucket: bucketName,
      Key: key,
    });

    const response = await s3.send(command);
    return response;
  }

  
module.exports = {
  s3,
  listBuckets,
  uploadFileToS3,
  getFileFromS3,
};