
import mongoose from 'mongoose';

const userSchema = new mongoose.Schema({
  username: { type: String, required: true, unique: true },
  password: { type: String, required: true },
  email: { type: String, required: true, unique: true },
  role: { type: String, default: 'user' },
  library: { type: [String], default: [] }, 
  borrowedBooks: [{
    type: mongoose.Schema.Types.ObjectId, 
    ref: 'Book'
  }]
});

export const User = mongoose.model('User', userSchema);

