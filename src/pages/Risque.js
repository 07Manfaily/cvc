import React from 'react';
import DataTable from 'react-data-table-component';
import { useNavigate } from 'react-router-dom';
import { Card, Stack, Container, Typography } from '@mui/material';
import VisibilityIcon from '@mui/icons-material/Visibility';
// import { useNavigate } from 'react-router-dom';
import Scrollbar from '../components/scrollbar';
import FilterComponent from '../utils/filter'

export default function Risque() {
  // Utilisez le hook useNavigate pour la navigation
  // const navigate = useNavigate();
  const navigate = useNavigate();
  const columns = [
    {
      name: 'N° client',
      selector: row => row.Nc,
    },
    {
      name: 'Segment',
      selector:row => row.seg,
      Cell: (props) => <span className="number">{props.value}</span>, // Custom cell components!
    },
    {
     name: 'FCCCR',
      selector: row => row.FC,
    },
    {
      name: 'Chargé client', // Custom header components!
      selector: row => row.Chgc,
    },
    {
      name: 'Priorité', // Custom header components!
      selector: row => row.Pr,
    },
    {
      name: 'Dernière validation',
      selector:  row => row.Dv,
    },
    {
      name: 'Action',
      button: true,
      cell: row => (
        <button onClick={() =>  navigate(`/dashboard/chaine-de-valeur`, { replace: true })}>
        <VisibilityIcon/>
        </button>
      ),
    },
  ];

  const data = [
    {
      Nc: '500144273',
      seg: 'Clientèle patrimoniale',
      Fc: 'Low Risk',
      Chgc: '282',
      Pr: 'red',
      Dv: '2023-09-15',
    },
    {
      Nc: '500581368',
      seg: 'Clientèle patrimoniale',
      Fc: 'Mid-Low Risk',
      Chgc: '282',
      Pr: 'red',
      Dv: '2023-09-15',
    },
    {
      Nc: '500981368',
      seg: 'Clientèle patrimoniale',
      Fc: 'Low Risk',
      Chgc: '282',
      Pr: 'red',
      Dv: '2023-09-15',
    },
    {
      Nc: '500583368',
      seg: 'Clientèle patrimoniale',
      Fc: 'Mid-Low Risk',
      Chgc: '282',
      Pr: 'red',
      Dv: '2023-09-15',
    },
    {
      Nc: '500581377',
      seg: 'Clientèle patrimoniale',
      Fc: 'Mid-Low Risk',
      Chgc: '282',
      Pr: 'red',
      Dv: '2023-09-15',
    },
    {
      Nc: '500581394',
      seg: 'Clientèle patrimoniale',
      Fc: 'Low Risk',
      Chgc: '282',
      Pr: 'red',
      Dv: '2023-09-15',
    },
    {
      Nc: '544581368',
      seg: 'Clientèle patrimoniale',
      Fc: 'Mid-Low Risk',
      Chgc: '282',
      Pr: 'red',
      Dv: '2023-09-15',
    },
    {
      Nc: '500583368',
      seg: 'Clientèle patrimoniale',
      Fc: 'Mid-Low Risk',
      Chgc: '282',
      Pr: 'red',
      Dv: '2023-09-15',
    },
    {
      Nc: '500581377',
      seg: 'Clientèle patrimoniale',
      Fc: 'Mid-Low Risk',
      Chgc: '282',
      Pr: 'red',
      Dv: '2023-09-15',
    },
    {
      Nc: '500581394',
      seg: 'Clientèle patrimoniale',
      Fc: 'Low Risk',
      Chgc: '282',
      Pr: 'red',
      Dv: '2023-09-15',
    },
    {
      Nc: '544581368',
      seg: 'Clientèle patrimoniale',
      Fc: 'Mid-Low Risk',
      Chgc: '282',
      Pr: 'red',
      Dv: '2023-09-15',
    },
  ];
  const [filterText, setFilterText] = React.useState('');
  const [resetPaginationToggle, setResetPaginationToggle] = React.useState(false);
  const filteredItems = data.filter((item) => item.Nc && item.Nc.toLowerCase().includes(filterText.toLowerCase()));
  const subHeaderComponentMemo = React.useMemo(() => {
    const handleClear = () => {
      if (filterText) {
        setResetPaginationToggle(!resetPaginationToggle);
        setFilterText('');
      }
    };
    return (
      <FilterComponent onFilter={(e) => setFilterText(e.target.value)} onClear={handleClear} filterText={filterText} />
    );
  }, [filterText, resetPaginationToggle]);
  return (
    <Container>
      <Stack direction="row" alignItems="center" justifyContent="space-between" mb={5}>
        <Typography variant="h4" gutterBottom>
          Clients
        </Typography>
        {/* <Button
          variant="contained"
          onClick={() => navigate('/create-product')}
          startIcon={<Iconify icon="eva:plus-fill" />}
        >
          New Product
        </Button> */}
      </Stack>
      <Card>
        <Scrollbar>
          <DataTable
        
            columns={columns}
            data={filteredItems}
            pagination
            paginationResetDefaultPage={resetPaginationToggle} // optionally, a hook to reset pagination to page 1
            subHeader
            subHeaderComponent={subHeaderComponentMemo}
            persistTableHead
          />
          
        </Scrollbar>
      </Card>
    </Container>
  );
}
