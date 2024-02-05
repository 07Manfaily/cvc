import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
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
  const [error, setError] = useState('')
  const [username, setUsername]  = useState('')
  const [password, setPassword]  =  useState('')

  const handleLogin = () => {
    if (username === '' || password === '') {
      setError('Les champs sont vides');
    } else { 
      setError(''); // Effacez les erreurs précédentes s'il y en avait
      navigate(`/dashboard`, { replace: true }); 
    }
  };
  return (
    <>
      <Stack spacing={3}>
      { error ?  <Alert variant="outlined" severity="error">
           {  error}
      </Alert>: ""}
        <TextField name="email" label="Email address"  value={username} onChange={(e) => setUsername(e.target.value)} />
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
