const mysql = require('mysql2/promise');
const pass = require('./pass');
const fs = require('fs');
const express = require("express");
const app = express();

const createConnection = async () => {
    return await mysql.createConnection({
        host: 'localhost',
        user: 'root',
        password: pass,
        database: 'estateagencymodified',
        port: 3300,
    });
};


const connection = mysql.createConnection({
        host: 'localhost',
        user: 'root',
        password: 'FreshMan12!',
        database: 'estateagencymodified',
        port: 3300,
    });
async function saveFileToDatabase(filePath, dealId) {
    const connection = await createConnection();
    const fileContent = fs.readFileSync(filePath);
    const query = "UPDATE deals SET deal_document = ? ";
    const [results] = await connection.query(query, [fileContent]);
    connection.end();
}
// saveFileToDatabase("test.pdf");




async function getFileFromDatabase(dealId, outputFilePath) {
    try {
        const connection = await createConnection();
        const query = "SELECT deal_document FROM deals WHERE deal_id = ?";
        const [rows] = await connection.execute(query, [dealId]);
        if (rows.length === 0) {
            console.log("Файл не знайдено для deal_id:", dealId);
            return;
        }
        const fileContent = rows[0].deal_document;
        fs.writeFileSync(outputFilePath, fileContent);
        console.log(`Файл успішно збережено за шляхом: ${outputFilePath}`);
        await connection.end();
    } catch (error) {
        console.error("Помилка при отриманні файлу з бази даних:", error);
    }
}

getFileFromDatabase(1, "output.pdf");







