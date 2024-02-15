import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import axios from 'axios';

// @mui
import { Stack, IconButton, InputAdornment, TextField, Checkbox, Typography } from '@mui/material';
import { LoadingButton } from '@mui/lab';
import Alert from '@mui/material/Alert';

// components
import Iconify from '../../../components/iconify';

// ----------------------------------------------------------------------

export default function LoginForm() {
  const navigate = useNavigate();

  const [showPassword, setShowPassword] = useState(false);
  const [error, setError] = useState('');
  const [matricule, setMatricule] = useState('');
  const [password, setPassword] = useState('');

  const handleLogin = async () => {
    if (matricule === '' || password === '') {
      setError('Les champs sont vides');
    } else {
      await axios
      .post('/user/login', { matricule: matricule, password: password })
      .then((response) => {
        console.log("reponse de l'api du login: ", response);
        const userData = response.data.data;
        localStorage.setItem('accessToken', userData[0].token.access_token);
        localStorage.setItem('username', userData[0].user);

          // const matricule = data.first_name+" "+data.last_name

          if (response.status === 200) {
            navigate(`/dashboard/chaine-de-valeur`, { replace: true });
          } else {
            console.log('Mauvaise information de connexion');
            setError('Mauvaise information de connexion');
          }
          if (response.status === 500) {
            setError('erreur liée au serveur');
          } else {
            setError('');
          }
        })
        .catch((error) => {
          console.log('Error lors du traitement:', error);
          setError('Oups !!!! erreur liée au serveur');
          console.log(error.response?.data || "Oups!!!! une erreur s'est produite");
        });
    }
  };

  return (
    <>
      <Stack spacing={3}>
        {error ? (
          <Alert variant="outlined" severity="error">
            {error}
          </Alert>
        ) : (
          ''
        )}
        <TextField
          name="identifiant"
          label="Identifiant"
          value={matricule}
          onChange={(e) => setMatricule(e.target.value)}
        />
        <TextField
          name="password"
          label="Password"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          type={showPassword ? 'text' : 'password'}
          InputProps={{
            endAdornment: (
              <InputAdornment position="end">
                <IconButton onClick={() => setShowPassword(!showPassword)} edge="end">
                  <Iconify icon={showPassword ? 'eva:eye-fill' : 'eva:eye-off-fill'} />
                </IconButton>
              </InputAdornment>
            ),
          }}
        />
      </Stack>

      <Stack direction="row" alignItems="center" justifyContent="space-between" sx={{ my: 2 }}>
        <div style={{ display: 'flex', alignItems: 'center' }}>
          <Checkbox name="remember" />
          <Typography variant="body2">Se souvenir de moi</Typography>
        </div>
      </Stack>

      <LoadingButton fullWidth size="large" type="submit" variant="contained" onClick={handleLogin}>
        Se connecter
      </LoadingButton>
    </>
  );
}
