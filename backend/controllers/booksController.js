import { Book } from '../models/bookModel.js';


export default () => {
  const getAllBooks = (req, res) => {
    Book.find()
      .then(books => res.status(200).json(books))
      .catch(() => res.status(500).json({ message: 'Erreur lors de la récupération des livres' }));
  };

  const getBookById = (req, res) => {
    const bookId = req.params.id;
    Book.findById(bookId)
   
      .then(book => {
        if (book) {
          res.status(200).json(book);
          console.log('Fetched Book:', book);
        } else {
          res.status(404).json({ message: 'Book not found' });
        }
      })
      .catch(() => res.status(500).json({ message: 'Erreur du serveur' }));
  };


  
  const addBook = (req, res) => {
    const { title, author, year, description,cover} = req.body;
  
    const newBook = new Book({ title, author, year, description,cover}); 
  
    newBook.save()
      .then(book => res.status(201).json({ message: 'Book added successfully', book }))
      .catch(() => res.status(500).json({ message: 'Erreur lors de l’ajout du livre' }));
  };




  const deleteBook = (req, res) => {
    const bookId = req.params.id; 
  
    Book.findByIdAndDelete(bookId)
      .then(book => {
        if (book) {
          res.status(200).json({ message: 'Livre supprimé avec succès' });
        } else {
          res.status(404).json({ message: 'Livre non trouvé' });
        }
      })
      .catch(() => res.status(500).json({ message: 'Erreur lors de la suppression du livre' }));
  };
  
  const updateBook = (req, res) => {
    const bookId = req.params.id; 
    const { title, author, year, description, cover } = req.body; 
  
    Book.findByIdAndUpdate(bookId, { title, author, year, description, cover }, { new: true })
      .then(book => {
        if (book) {
          res.status(200).json({ message: 'Livre mis à jour avec succès', book });
        } else {
          res.status(404).json({ message: 'Livre non trouvé' });
        }
      })
      .catch(() => res.status(500).json({ message: 'Erreur lors de la mise à jour du livre' }));
  };




const borrowBook = (req, res) => {
  const bookId = req.params.id; 
  const userId = req.body.userId; 

  console.log('User ID reçu:', userId);

 
  Book.findById(bookId)
    .then(book => {
      if (!book) {
        console.log('Livre non trouvé'); 
        return res.status(404).json({ message: 'Livre non trouvé' });
      }

      if (book.borrowed) {
        console.log('Livre déjà emprunté'); 
        return res.status(400).json({ message: 'Le livre est déjà emprunté' });
      }

     
      book.borrowed = true;
      book.borrowedBy = userId;
      book.borrowDate = new Date();
      book.returnDate = new Date(Date.now() + 7 * 24 * 60 * 60 * 1000); 

      
      book.save()
        .then(updatedBook => {
          console.log('Livre mis à jour:', updatedBook);
          res.status(200).json({ message: 'Livre emprunté avec succès', book: updatedBook });
        })
        .catch(error => {
          console.error('Erreur de sauvegarde:', error);
          res.status(500).json({ message: 'Erreur lors de l\'emprunt du livre' });
        });
    })
    .catch(error => {
      console.error('Erreur de serveur:', error);
      res.status(500).json({ message: 'Erreur du serveur' });
    });
};





const getBooksBorrowedByUser = (req, res) => {
  const userId = req.params.userId; 
  console.log('UserID:', userId);


  Book.find({ borrowedBy: userId, borrowed: true })
    .then(books => {
      if (books.length === 0) {
        return res.status(404).json({ message: 'Aucun livre emprunté trouvé pour cet utilisateur' });
      }
      res.status(200).json(books);
    })
    .catch(error => {
      console.error('Erreur lors de la récupération des livres empruntés:', error);
      res.status(500).json({ message: 'Erreur du serveur' });
    });
};




  return {
    deleteBook,
    updateBook,
    getAllBooks,
    getBookById,
    addBook,
    borrowBook,
    getBooksBorrowedByUser
  };
};
