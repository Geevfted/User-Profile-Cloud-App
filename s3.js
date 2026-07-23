const {
  S3Client,
  PutObjectCommand,
  GetObjectCommand,
} = require("@aws-sdk/client-s3");

const fs = require("fs");

const s3 = new S3Client({
  region: process.env.AWS_REGION,
});


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
  uploadFileToS3,
  getFileFromS3,
};