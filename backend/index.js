import express from 'express';
import bodyParser from 'body-parser';
import cors from 'cors';

import mongoose from 'mongoose';
import userRoutes from './routes/userRoutes.js';
import bookRoutes from './routes/bookRoutes.js';
import { Book } from './models/bookModel.js'; 

const PORT = 3000;
const app = express();
const hostname = '0.0.0.0';

app.use(bodyParser.json());
app.use(cors());


mongoose.connect('mongodb://localhost:27017/libraryBD', {
  useNewUrlParser: true,
  useUnifiedTopology: true,
})
  .then(() => console.log('Connecté à MongoDB'))
  .catch(err => console.error('Erreur de connexion à MongoDB:', err));


app.use('/api/users', userRoutes());
app.use('/api/books', bookRoutes());

app.listen(PORT, hostname, () => {
  console.log(`Serveur en cours d'exécution sur http://${hostname}:${PORT}/`);
});
