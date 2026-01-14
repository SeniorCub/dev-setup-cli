#!/usr/bin/env bash


PROJECT_NAME=$1

if [ -z "$PROJECT_NAME" ]; then
  # If no argument, ask for it
  read -p "Enter project name (default: my-nodejs-api): " INPUT_NAME
  PROJECT_NAME=${INPUT_NAME:-my-nodejs-api}
fi

if [ -d "$PROJECT_NAME" ]; then
  echo "Error: Directory '$PROJECT_NAME' already exists."
  exit 1
fi

echo "🚀 Setting up Node.js API boilerplate in '$PROJECT_NAME'..."

# Create root folder
mkdir -p "$PROJECT_NAME"
cd "$PROJECT_NAME" || exit

# Create package.json
cat > package.json <<EOF
{
  "name": "$PROJECT_NAME",
  "version": "1.0.0",
  "description": "Node.js API Boilerplate",
  "main": "server.js",
  "scripts": {
    "start": "node server.js",
    "dev": "nodemon server.js"
  },
  "keywords": [],
  "author": "",
  "license": "ISC",
  "dependencies": {
    "express": "^4.18.2",
    "dotenv": "^16.3.1",
    "cors": "^2.8.5",
    "mongoose": "^8.0.0",
    "helmet": "^7.1.0",
    "morgan": "^1.10.0"
  },
  "devDependencies": {
    "nodemon": "^3.0.1"
  }
}
EOF

# Create directory structure
echo "📂 Creating directory structure..."

# bin directory
mkdir -p bin
touch bin/cli.js

# Config files
mkdir -p config
cat > config/database.js <<EOF
const mongoose = require('mongoose');

const connectDB = async () => {
    try {
        const conn = await mongoose.connect(process.env.MONGO_URI || 'mongodb://localhost:27017/$PROJECT_NAME');
        console.log(`MongoDB Connected: ${conn.connection.host}`);
    } catch (error) {
        console.error(`Error: ${error.message}`);
        process.exit(1);
    }
};

module.exports = connectDB;
EOF
touch config/middleware.js config/routes.js

# Controllers
mkdir -p controllers
cat > controllers/authController.js <<EOF
exports.register = (req, res) => {
    res.status(200).json({ success: true, message: 'Register route' });
};

exports.login = (req, res) => {
    res.status(200).json({ success: true, message: 'Login route' });
};
EOF
touch controllers/userController.js

# Middleware
mkdir -p middleware
touch middleware/auth.js middleware/kyc.js middleware/security.js
cat > middleware/errorHandler.js <<EOF
const errorHandler = (err, req, res, next) => {
    console.error(err.stack);
    res.status(500).json({
        success: false,
        error: err.message || 'Server Error'
    });
};

module.exports = errorHandler;
EOF

# Models
mkdir -p models
cat > models/User.js <<EOF
const mongoose = require('mongoose');

const UserSchema = new mongoose.Schema({
    name: {
        type: String,
        required: [true, 'Please add a name']
    },
    email: {
        type: String,
        required: [true, 'Please add an email'],
        unique: true,
        match: [
            /^\w+([.-]?\w+)*@\w+([.-]?\w+)*(\.\w{2,3})+$/,
            'Please add a valid email'
        ]
    },
    password: {
        type: String,
        required: [true, 'Please add a password'],
        minlength: 6,
        select: false
    },
    createdAt: {
        type: Date,
        default: Date.now
    }
});

module.exports = mongoose.model('User', UserSchema);
EOF

# Routes
mkdir -p routes
cat > routes/authRoutes.js <<EOF
const express = require('express');
const router = express.Router();
const { register, login } = require('../controllers/authController');

router.post('/register', register);
router.post('/login', login);

module.exports = router;
EOF
touch routes/userRoutes.js

# Utils
mkdir -p utils
touch utils/apiResponse.js utils/appError.js utils/catchAsync.js utils/cloudinary.js utils/email.js utils/paystack.js utils/security.js utils/sms.js

# Public folder
mkdir -p public
cat > public/index.html <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>$PROJECT_NAME API</title>
</head>
<body>
    <h1>Welcome to $PROJECT_NAME API</h1>
</body>
</html>
EOF

# Uploads
mkdir -p uploads
touch uploads/.gitkeep

# Docs & Postman
mkdir -p docs postman
touch docs/api.md postman/collection.json

# Root files
touch .gitignore
cat > .env <<EOF
NODE_ENV=development
PORT=5000
MONGO_URI=mongodb://localhost:27017/$PROJECT_NAME
EOF

cat > server.js <<EOF
const express = require('express');
const dotenv = require('dotenv');
const morgan = require('morgan');
const connectDB = require('./config/database');
const errorHandler = require('./middleware/errorHandler');

// Load env vars
dotenv.config();

// Connect to database
// connectDB(); // Uncomment after setting up MongoDB

const app = express();

// Body parser
app.use(express.json());

// Dev logging middleware
if (process.env.NODE_ENV === 'development') {
    app.use(morgan('dev'));
}

// Mount routers
const authRoutes = require('./routes/authRoutes');
app.use('/api/v1/auth', authRoutes);

app.get('/', (req, res) => {
    res.sendFile(__dirname + '/public/index.html');
});

app.use(errorHandler);

const PORT = process.env.PORT || 5000;

const server = app.listen(PORT, console.log(`Server running in ${process.env.NODE_ENV} mode on port ${PORT}`));

// Handle unhandled promise rejections
process.on('unhandledRejection', (err, promise) => {
    console.log(`Error: ${err.message}`);
    // Close server & exit process
    server.close(() => process.exit(1));
});
EOF

echo "✅ Boilerplate created successfully!"

# Ask to install dependencies
read -p "📦 Do you want to install dependencies now? (Y/n) " install_choice
if [[ -z "$install_choice" || "$install_choice" =~ ^[Yy]$ ]]; then
    echo "Installing dependencies..."
    npm install
    
    # Ask to start dev server (only if installed)
    read -p "🚀 Do you want to start the development server? (Y/n) " start_choice
    if [[ -z "$start_choice" || "$start_choice" =~ ^[Yy]$ ]]; then
        echo "Starting server..."
        npm run dev
    else
        echo "👉 You can start the server later with: npm run dev"
    fi
else
    echo "👉 Next steps:"
    echo "   cd $PROJECT_NAME"
    echo "   npm install"
    echo "   npm run dev"
fi
