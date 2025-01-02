
import mongoose from 'mongoose';

const bookSchema = new mongoose.Schema({
  title: { type: String, required: true },
  author: { type: String, required: true },
  year: { type: Number, required: true },
  description: { type: String, required: true },
  cover: { type: String },
  borrowed: { type: Boolean, default: false }, 
  borrowedBy: { type: mongoose.Schema.Types.ObjectId, ref: 'User' }, 
  borrowDate: { type: Date }, 
  returnDate: { type: Date } 
});

export const Book = mongoose.model('Book', bookSchema);


