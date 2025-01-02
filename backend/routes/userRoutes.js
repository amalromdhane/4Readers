import express from 'express';
import usersController from '../controllers/usersController.js';

const router = express.Router();
const controller = usersController();


router.post('/register', controller.registerUser);
router.post('/login', controller.loginUser);
router.get('/library/:userId', controller.getLibrary);
router.post('/library', controller.addBookToLibrary);
router.delete('/:userId', controller.deleteUser);
router.put('/update/:userId', controller.updateUser);
router.get('/user', controller.getAllUsers);
router.post('/', controller.addUser);

export default () => router;
