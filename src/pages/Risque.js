// import React from 'react';

// import ReactTable from 'react-table';

// import {
//   Card,
//   Stack,
//   Container,
//   Typography,
// } from '@mui/material';
// // import { useNavigate } from 'react-router-dom';
// import Scrollbar from '../components/scrollbar';

// const data = [
//   {
//     name: 'Tanner Linsley',
//     age: 26,
//     friend: {
//       name: 'Jason Maurer',
//       age: 23,
//     },
//   },
// ];

// const columns = [
//   {
//     Header: 'Name',
//     accessor: 'name',
//   },
//   {
//     Header: 'Age',
//     accessor: 'age',
//   },
//   {
//     Header: 'Friend Name',
//     accessor: (d) => d.friend.name,
//   },
//   {
//     Header: 'Friend Age',
//     accessor: 'friend.age',
//   },
// ];

// export default function Risque() {
//   // Utilisez le hook useNavigate pour la navigation
//  // const navigate = useNavigate();

//   return (
//     <Container>
//       <Stack direction="row" alignItems="center" justifyContent="space-between" mb={5}>
//         <Typography variant="h4" gutterBottom>
//           Products
//         </Typography>
//         {/* <Button
//           variant="contained"
//           onClick={() => navigate('/create-product')}
//           startIcon={<Iconify icon="eva:plus-fill" />}
//         >
//           New Product
//         </Button> */}
//       </Stack>
//       <Card>
//         <Scrollbar>
//           <ReactTable data={data} columns={columns} />
//         </Scrollbar>
//       </Card>
//     </Container>
//   );
// }
