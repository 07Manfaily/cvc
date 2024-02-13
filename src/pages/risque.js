import React, { useState } from 'react';
import { useTable, useGlobalFilter } from 'react-table';
import { Link } from 'react-router-dom';
import { Card, Stack, Container, Typography, TextField } from '@mui/material';
import VisibilityIcon from '@mui/icons-material/Visibility';
import Scrollbar from '../components/scrollbar';

export default function Risque() {
  const [filterInput, setFilterInput] = useState('');

  const handleFilterChange = (e) => {
    const value = e.target.value || '';
    setFilterInput(value);
  };

  const columns = [
    {
      Header: 'N° client',
      accessor: 'Nc',
    },
    {
      Header: 'Segment',
      accessor: 'seg',
    },
    {
      Header: 'F',
      accessor: 'Fc',
    },
    {
      Header: 'Chargé client',
      accessor: 'Chgc',
    },
    {
      Header: 'Priorité',
      accessor: 'Pr',
    },
    {
      Header: 'Dernière validation',
      accessor: 'Dv',
    },
    {
      Header: '',
      accessor: 'action',
      Cell: () => (
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
      seg: 'Client',
      Fc: 'Low Risk',
      Chgc: '2',
      Pr: 'red',
      Dv: '2',
    },
  ];

  const {
    getTableProps,
    getTableBodyProps,
    headerGroups,
    rows,
    prepareRow,
    state,
    setGlobalFilter,
  } = useTable(
    { columns, data },
    useGlobalFilter
  );

  const { globalFilter } = state;

  return (
    <Container>
      <Stack direction="row" alignItems="center" justifyContent="space-between" mb={5}>
        <Typography variant="h4" gutterBottom>
          Clients
        </Typography>
        <TextField
          id="search"
          label="Search"
          variant="outlined"
          value={filterInput}
          onChange={handleFilterChange}
        />
      </Stack>
      <Card>
        <Scrollbar>
          <table {...getTableProps()} className="table_boucle -striped -highlight">
            <thead>
              {headerGroups.map((headerGroup) => (
                <tr {...headerGroup.getHeaderGroupProps()}>
                  {headerGroup.headers.map((column) => (
                    <th {...column.getHeaderProps()}>{column.render('Header')}</th>
                  ))}
                </tr>
              ))}
            </thead>
            <tbody {...getTableBodyProps()}>
              {rows.map((row, i) => {
                prepareRow(row);
                return (
                  <tr {...row.getRowProps()} key={i}>
                    {row.cells.map((cell) => {
                      return <td {...cell.getCellProps()}>{cell.render('Cell')}</td>;
                    })}
                  </tr>
                );
              })}
            </tbody>
          </table>
        </Scrollbar>
      </Card>
    </Container>
  );
}
