import { User } from '../models/userModel.js';
import { Book } from '../models/bookModel.js';


export default () => {
 



  const loginUser = (req, res) => {
    console.log("Login request received"); 
    const { email, password } = req.body;
  
    User.findOne({ email, password })
      .then(user => {
        if (user) {
          console.log("User data:", user); 
          res.status(200).json({
            message: 'Login successful',
            token: `token_${user._id}`,
            role: user.role,  
            userId: user._id
          });
        } else {
          res.status(401).json({ message: 'Invalid credentials' });
        }
      })
      .catch(() => res.status(500).json({ message: 'Server error' }));
  };
  

  const registerUser = (req, res) => {
    const { username, password, email, role } = req.body;
  
    User.findOne({ username })
      .then(existingUser => {
        if (existingUser) {
          res.status(400).json({ message: 'Username already taken' });
          return;
        }
  
        
        const newUser = new User({ 
          username, 
          password, 
          email, 
          role: role || 'user', 
          library: [] 
        });
  
        newUser.save()
          .then(user => res.status(201).json({ message: 'User registered successfully', user }))
          .catch(() => res.status(500).json({ message: 'Erreur lors de l’enregistrement de l’utilisateur' }));
      })
      .catch(() => res.status(500).json({ message: 'Erreur du serveur' }));
  };
  








  const getLibrary = (req, res) => {
    const userId = req.params.userId;
    User.findById(userId)
      .then(user => {
        if (user) {
          Book.find({ '_id': { $in: user.library } })
            .then(books => res.status(200).json(books))
            .catch(() => res.status(500).json({ message: 'Erreur lors de la récupération des livres' }));
        } else {
          res.status(404).json({ message: 'User not found' });
        }
      })
      .catch(() => res.status(500).json({ message: 'Erreur du serveur' }));
  };

  const addBookToLibrary = (req, res) => {
    const { userId, bookId } = req.body;

    User.findById(userId)
      .then(user => {
        if (!user) {
          res.status(400).json({ message: 'Invalid user' });
          return;
        }

        Book.findById(bookId)
          .then(book => {
            if (!book) {
              res.status(400).json({ message: 'Invalid book' });
              return;
            }

            user.library.push(book._id); 

            user.save()
              .then(() => res.status(200).json({ message: 'Book added to library' }))
              .catch(() => res.status(500).json({ message: 'Erreur lors de la mise à jour de la bibliothèque' }));
          })
          .catch(() => res.status(500).json({ message: 'Erreur du serveur' }));
      })
      .catch(() => res.status(500).json({ message: 'Erreur du serveur' }));
  };
/*-------------------UPDATE USER-------------------------*/
const updateUser = (req, res) => {
  const userId = req.params.userId;
  const { username, email, role } = req.body;

  User.findById(userId)
    .then(user => {
      if (!user) {
        console.error('User not found');
        res.status(404).json({ message: 'User not found' });
        return;
      }

      if (username) user.username = username;
      if (email) user.email = email;
      if (role) user.role = role;

      user.save()
        .then(updatedUser => {
          res.status(200).json({ message: 'User updated successfully', user: updatedUser });
        })
        .catch(error => {
          console.error('Error saving user:', error);
          res.status(500).json({ message: 'Error updating user' });
        });
    })
    .catch(error => {
      console.error('Error finding user:', error);
      res.status(500).json({ message: 'Error finding user' });
    });
};

 /*------------------- FIN UPDATE USER-------------------------*/

/*--------------------DELETE USER -----------------------------*/
const deleteUser = (req, res) => {
  const userId = req.params.userId;

  User.findByIdAndDelete(userId)
    .then(user => {
      if (user) {
        res.status(200).json({ message: 'User deleted successfully' });
      } else {
        res.status(404).json({ message: 'User not found' });
      }
    })
    .catch(() => res.status(500).json({ message: 'Error deleting user' }));
};

/*------------------------FIN DELETE USER --------------------------*/

/*------------------------ALL USERS --------------------------*/
const getAllUsers = (req, res) => {
  
  // Trouver tous les utilisateurs dans la base de données
  User.find()
    .then(users => {
      res.status(200).json(users);
    })
    .catch(err => {
      res.status(500).json({ message: 'Erreur lors de la récupération des utilisateurs', error: err });
    });
};

/*------------------------FIN ALL USERS--------------------------*/



const addUser = (req, res) => {
  console.log('Received request to add user');
  const { username, password, email, role } = req.body;

  const newUser = new User({ username, password, email, role }); 

  newUser.save()
    .then(user => res.status(201).json({ message: 'User added successfully', user }))
    .catch(err => {
      console.error('Error adding user:', err);
      res.status(500).json({ message: 'Erreur lors de l’ajout du User' });
    });
};



  return {
    registerUser,
    loginUser,
    getLibrary,
    addBookToLibrary,
    deleteUser,
    updateUser,
    getAllUsers,
    addUser
  };
};

