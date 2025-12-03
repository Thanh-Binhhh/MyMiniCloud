require("dotenv").config();

const express = require("express");
const axios = require("axios");
const fs = require("fs");
const jwt = require("jose");
const app = express();

const PORT = 8081;
const ISSUER = process.env.OIDC_ISSUER;
const AUDIENCE = process.env.OIDC_AUDIENCE;
const JWKS_URL = `${ISSUER}/protocol/openid-connect/certs`;

let _JWKS = null;
let _TS = 0;

async function getJWKS() {
    const now = Date.now() / 1000;
    if (!_JWKS || now - _TS > 600) {
        const res = await axios.get(JWKS_URL, { timeout: 5000 });
        _JWKS = res.data;
        _TS = now;
    }
    return _JWKS;
}

app.get("/hello", (req, res) => {
    res.json({ message: "Hello from App Server!" });
});

app.get("/secure", async (req, res) => {
    const auth = req.headers["authorization"] || "";
    if (!auth.startsWith("Bearer ")) {
        return res.status(401).json({ error: "Missing Bearer token" });
    }
    const token = auth.split(" ")[1];

    const decodedHeader = jwt.decodeJwt(token, { complete: true });
    console.log("💡Decoded header:", decodedHeader);
    console.log(`💡ISSUER: ${ISSUER}`)

    try {
        const JWKS = await getJWKS();
        const keyStore = jwt.createRemoteJWKSet(new URL(JWKS_URL));
        const { payload } = await jwt.jwtVerify(token, keyStore, {
            audience: AUDIENCE,
            // issuer: ISSUER
        });
        res.json({
            message: "Secure resource OK",
            preferred_username: payload.preferred_username
        });
    } catch (err) {
        console.log(`📌 ${err}`)
        res.status(401).json({ error: err.toString() });
    }
});

app.get("/student", (req, res) => {
    fs.readFile("data.json", "utf8", (err, data) => {
        if (err) {
            return res.status(500).json({ error: "Cannot read file" });
        }

        const jsonData = JSON.parse(data);
        return res.json(jsonData);
    });
});

app.listen(PORT, "0.0.0.0", () => {
    console.log(`Backend server running on port ${PORT}`);
});