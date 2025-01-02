import express from 'express';
const router = express.Router();
import booksController from '../controllers/booksController.js';


  const controller = booksController();

  router.get('/', controller.getAllBooks);
  router.get('/:id', controller.getBookById);
  router.post('/', controller.addBook);
  router.delete('/:id', controller.deleteBook); 
  router.put('/:id', controller.updateBook); 
  router.put('/borrow/:id', controller.borrowBook); 
  router.get('/borrowedBy/:userId', controller.getBooksBorrowedByUser);


  export default () => router;




 


