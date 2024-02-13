import React from 'react';
import ReactTable from 'react-table';
import { Link } from 'react-router-dom';
import { Card, Stack, Container, Typography } from '@mui/material';
import VisibilityIcon from '@mui/icons-material/Visibility';
import Scrollbar from '../components/scrollbar';

export default function Risque() {

  const columns = [
    {
      Header: 'N° client',
      accessor: 'Nc', // String-based value accessors!
    },
    {
      Header: 'Segment',
      accessor: 'seg',
      Cell: (props) => <span className="number">{props.value}</span>, // Custom cell components!
    },
    {
      Header: 'F',
      accessor: 'Fc',
    },
    {
      Header: (props) => <span>Chargé client</span>, // Custom header components!
      accessor: 'Chgc',
    },
    {
      Header: (props) => <span>Priorité</span>, // Custom header components!
      accessor: 'Pr',
    },
    {
      Header: 'Dernière validation',
      accessor: 'Dv',
    },
    {
      Header: '',
      accessor: 'action',
      Cell: (props) => (
        <Link to={`/dashboard/chaine-de-valeur/`} className="action-button">
          <button>
            <VisibilityIcon />
          </button>
        </Link>
      ),
    },
  ];

  const data = [
    {
      Nc: '3',
      seg: 'Clien',
      Fc: 'Low Risk',
      Chgc: '2',
      Pr: 'red',
      Dv: '2',
    },
    
  ];
  return (
    <Container>
      <Stack direction="row" alignItems="center" justifyContent="space-between" mb={5}>
        <Typography variant="h4" gutterBottom>
          Clients
        </Typography>

      </Stack>
      <Card>
        <Scrollbar>
       
           <ReactTable
            className="table_boucle -striped -highlight"
            columns={columns}
            data={data}
            defaultPageSize={10}
            filterable
            defaultFilterMethod={(filter, row) => String(row[filter.id]).startsWith(filter.value)}
          /> 
        </Scrollbar>
      </Card>
    </Container>
  );
}
