import React, { useState, useEffect } from 'react';
import axios from "axios";
import { useParams } from "react-router-dom";
import getCookie from 'app/utils/getCookies';
import { fNumber } from 'app/utils/formatNumber';
import {
  Grid,
  TableCell,
  TableBody,
  TextField,
  TableContainer,
  Table,
  Paper,
  TableHead,
  TableRow
} from '@mui/material';

export default function Engagement({sendEngagement}) {
  const { Id } = useParams();
  const [data, setData] = useState({});
  const [values, setValues] = useState({});

  const handleEngagement = async () => {
    try {
      const response = await axios.post(
        "/api/commitment/summary",
        { number_client: Id },
        {
          headers: {
            "Content-Type": "application/json",
            "X-CSRF-TOKEN": getCookie("csrf_refresh_token"),
          },
        }
      );
      if (response.status === 200) {
        setData(response.data.data);
      }
    } catch (error) {
      console.log("Error lors du traitement de before inside:", error);
    }
  };

 
const handleSendEngagement = async () => {
  try {
    const response = await axios.post(
      "/api/commitment/summary/set",
      {"data": values,
       "number_client": Id },
      {
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-TOKEN": getCookie("csrf_refresh_token"),
        },
      }
    );

  } catch (error) {
    console.log("Error lors du traitement de before inside:", error);
  }
};
useEffect(() => {
  if(sendEngagement){
    sendEngagement(handleSendEngagement)
  }
}, [sendEngagement]);

  useEffect(() => {
    if (Id) {
      handleEngagement();
    }
  }, [Id]);
 
  const handleChange = (key) => (event) => {
    setValues({ ...values, [key]: event.target.value });
  };

  console.log("valeur", values);
  handleSendEngagement(values, Id)
  return (
    <Grid item xs={12} md={12}>
      <TableContainer component={Paper}>
        <Table sx={{ minWidth: 650, border: '1px solid #9B9B9B', background:  `linear-gradient(#EEEEEE, #EEEEEE)`  }} aria-label="caption table">
          <TableHead>
            <TableRow>
              <TableCell></TableCell>
              <TableCell><b>Autorisations précédentes</b></TableCell>
              <TableCell><b>Total Autorisations Sollicitées</b></TableCell>
              <TableCell><b>Variation</b></TableCell>
              <TableCell><b>% Variation</b></TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {Object.entries(data).map(([key, value]) => (
              <TableRow key={key}>
                <TableCell>
                  <b style={{ color: '#b71c1c' }}>&lt;={key}</b>
                </TableCell>
                <TableCell>
                  <b style={{ color: '#283593' }}>
                    {value === null ? '---------' : fNumber(value)}
                  </b>
                </TableCell>
                <TableCell>
                  <TextField
                    style={{ backgroundColor: '#f5f5f5', border: '2px solid black' }}
                    id={`filled-basic-${key}`}
                    placeholder="........"
                    variant="filled"
                    value={values[key] || ''}
                    onChange={handleChange(key)}
                    type="number"
                  />
                </TableCell>
                <TableCell>
                  <b style={{ color: '#283593' }}>
                    {value === null
                      ? '---------'
                      : fNumber(isNaN(values[key] - value) ? '----------------' : values[key] - value)}
                  </b>
                </TableCell>
                <TableCell>
                  <b style={{ color: '#283593' }}>
                    {value === null
                      ? '---------'
                      : isNaN(((values[key] - value) / value) * 100)
                        ? '-------'
                        : (((values[key] - value) / value) * 100).toFixed(2)} %
                  </b>
                </TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </TableContainer>
    
    </Grid>
  );
}



import React, { useState, useEffect } from "react";
import axios from "axios";
import { useParams } from "react-router-dom";
import { Vortex } from "react-loader-spinner";

import {
  Grid,
  Button,
  TableCell,
  TableBody,
  TextField,
  TableContainer,
  Table,
  Paper,
  TableHead,
  TableRow,
  Modal,
  Backdrop,
  Fade,
  IconButton
} from "@mui/material";
import { Alert } from "@mui/lab";
import AddBoxIcon from "@mui/icons-material/AddBox";
import DeleteIcon from "@mui/icons-material/Delete";
import EditIcon from "@mui/icons-material/Edit";
import { fNumber } from "app/utils/formatNumber";
import getCookie from "app/utils/getCookies";
import { formatKeyResponseBeforeRequest } from "app/utils/constomizeResponse";


export default function BeforeRequest({sendValue}) {
  const { Id } = useParams();
  const [data, setData] = useState();
  const style = {
    position: "absolute",
    top: "50%",
    left: "50%",
    transform: "translate(-20%, -50%)",
    width: 700,
    bgcolor: "background.paper",
    border: "2px solid #000",
    boxShadow: 24,
    p: 4
  };

  const format = formatKeyResponseBeforeRequest;

  const [open, setOpen] = useState(false);
  const [editRow, setEditRow] = useState(null);

  const [loading, setLoading] = useState(true);
  const [nature, setNature] = useState("");
  const [compte, setCompte] = useState("");
  const [autorisation, setAutorisation] = useState("");
  const [encour, setEncour] = useState("");
  const [devise, setDevise] = useState("");
  const [delais, setDelais] = useState("");

  const handleModalOpen = () => {
    setEditRow(null);
    setOpen(true);
    setNature("");
    setCompte("");
    setAutorisation("");
    setEncour("");
    setDevise("");
    setDelais("");
  };

  const updateRow = (row) => {
    setEditRow(row);
    setOpen(true);
    setNature(row.title);
    setCompte(row.account_number);
    setAutorisation(row.autorisation_amount);
    setEncour(row.outstanding_amount);
    setDevise(row.devise);
    setDelais(row.maturity_date);
  };

  const deleteRow = (row) => {
    const newData = data.filter((line) => line !== row);
    setData(newData);
    setOpen(false);
  };

  const handleModalClose = () => {
    setOpen(false);
    setEditRow(null);
  };

  const columnTitle = [
    "title",
    "account_number",
    "devise",
    "autorisation_amount",
    "outstanding_amount",
    "maturity_date"
  ];
  const handleValue = async () => {
    try {
      const response = await axios.post(
        "/api/commitment/before_insight",
        { number_client: Id },
        {
          headers: {
            "Content-Type": "application/json",
            "X-CSRF-TOKEN": getCookie("csrf_refresh_token")
          }
        }
      );

      if (response.status === 200) {
        setLoading(false);

        setData(response.data.data);
        const val = response.data.data
          .map((item) =>
            Object.entries(item)
              .filter(([key]) =>
                [
                  "title",
                  "account_number",
                  "devise",
                  "autorisation_amount",
                  "outstanding_amount",
                  "maturity_date"
                ].includes(key)
              )
              .map(([key, value]) => `${key}:${value}`)
          )
          .flat();

        console.log("ee", val);
      }
    } catch (error) {
      setLoading(false);
      console.log("Error lors du traitement de before inside:", error);
    }
  };

  useEffect(() => {
    if (Id) {
      handleValue();
    }
  }, [Id]);


  const handleSendInsight = async () => {
    try {
      const response = await axios.post(
        "/api/commitment/after_insight",
        { data: data, number_client: Id },
        {
          headers: {
            "Content-Type": "application/json",
            "X-CSRF-TOKEN": getCookie("csrf_refresh_token")
          }
        }
      );
    } catch (error) {
      console.log("Error lors du traitement de before inside:", error);
    }
  };
  useEffect(() => {
    if(sendValue){
      sendValue(handleSendInsight)
    }
  }, [sendValue]);


  const handleChangeNatureLigne = (e) => {
    setNature(e.target.value);
  };

  const handleChangeNumberCompte = (e) => {
    setCompte(e.target.value);
  };

  const handleChangeAutorisation = (e) => {
    setAutorisation(e.target.value);
  };

  const handleChangeEncour = (e) => {
    setEncour(e.target.value);
  };

  const handleChangeDevise = (e) => {
    setDevise(e.target.value);
  };

  const handleChangeMaturityDate = (e) => {
    setDelais(e.target.value);
  };

  const handleFormSubmit = (values) => {
    const parsedValues = {
      matricule: Id,
      title: values["Nature de ligne"],
      account_number: values["Numero compte"],
      autorisation_amount: fNumber(values["Autorisation"]) || 0,
      outstanding_amount: fNumber(values["En cours"]) || 0,
      devise: values["Devise"],
      maturity_date: values["Délais de maturité"]
    };

    if (editRow) {
      const newData = data.map((line) => (line === editRow ? { ...line, ...parsedValues } : line));
      setData(newData);

    } else {
      setData([...data, parsedValues]);
   
    }
    handleModalClose();
  };

  return (
    <Grid container item xs={12} rowSpacing={2} spacing={2}>
      <Grid item xs={12} md={12}>
        <TableContainer component={Paper}>
          <Table
            sx={{ border: "1px solid #9B9B9B", background: `linear-gradient(#EEEEEE, #EEEEEE)` }}
            aria-label="caption table"
          >
            <caption>
              <Button onClick={handleModalOpen} style={{ background: "#33691e", color: "white" }}>
                <AddBoxIcon style={{ color: "white" }} />
              </Button>
            </caption>
            <TableHead>
              <TableRow>
                {data !== undefined
                  ? columnTitle.map((col) => (
                      <TableCell align="center" style={{ fontSize: "12px" }}>
                        <b>{format(col)}</b>
                      </TableCell>
                    ))
                  : null}
                <TableCell align="center" style={{ fontSize: "12px" }}>
                  <b>Action</b>
                </TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {loading ? (
                <Vortex
                  visible={loading}
                  height="80"
                  width="200"
                  ariaLabel="vortex-loading"
                  wrapperStyle={{}}
                  wrapperClass="vortex-wrapper"
                  colors={["red", "green", "blue", "yellow", "orange", "black"]}
                />
              ) : data && data.length > 0 ? (
                data.map((value) => (
                  <TableRow key={value.id}>
                    {columnTitle.map((col) => (
                      <TableCell align="center" style={{ fontSize: "12px" }}>
                        <b style={{ color: value[col] === "devise" ? "#dd2c00" : "#455a64" }}>
                          {value[col]}
                        </b>
                      </TableCell>
                    ))}
                    <TableCell align="center" style={{ fontSize: "12px" }}>
                      <IconButton onClick={() => deleteRow(value)}>
                        <DeleteIcon style={{ color: "red" }} />
                      </IconButton>
                      <IconButton onClick={() => updateRow(value)}>
                        <EditIcon style={{ color: "green" }} />
                      </IconButton>
                    </TableCell>
                  </TableRow>
                ))
              ) : (
                <Alert variant="filled" severity="error">
                  Aucune information liée au client
                </Alert>
              )}
            </TableBody>
          </Table>
        </TableContainer>
        <Modal
          style={{
            display: "flex",
            alignItems: "center",
            justifyContent: "center"
          }}
          aria-labelledby="transition-modal-title"
          aria-describedby="transition-modal-description"
          open={open}
          onClose={handleModalClose}
          closeAfterTransition
          BackdropComponent={Backdrop}
          BackdropProps={{
            timeout: 500
          }}
        >
          <Grid sx={style} container direction="column" spacing={4}>
            <Grid item>
              <h2>
                {editRow
                  ? `Modification de la ligne ${editRow.title}`
                  : "Ajouter une nouvelle ligne"}
              </h2>
            </Grid>
            <Grid item>
              <form
                onSubmit={(e) => {
                  e.preventDefault();
                  const formData = new FormData(e.target);
                  const val = {};
                  formData.forEach((value, key) => {
                    val[key] = value;
                  });
                  handleFormSubmit(val);
                }}
              >
                <Grid container direction="row" spacing={3} wrap="wrap">
                  <Grid item xs={4}>
                    <TextField
                      name="Nature de ligne"
                      id="outlined-basic"
                      label="Nature de ligne"
                      variant="outlined"
                      required
                      value={nature}
                      onChange={handleChangeNatureLigne}
                    />
                  </Grid>
                  <Grid item xs={4}>
                    <TextField
                      name="Numero compte"
                      id="outlined-basic"
                      label="Numero compte"
                      variant="outlined"
                      required
                      value={compte}
                      onChange={handleChangeNumberCompte}
                    />
                  </Grid>
                  <Grid item xs={4}>
                    <TextField
                      name="Autorisation"
                      id="outlined-basic"
                      label="Autorisation"
                      variant="outlined"
                      required
                      value={autorisation}
                      onChange={handleChangeAutorisation}
                    />
                  </Grid>
                  <Grid item xs={4}>
                    <TextField
                      name="En cours"
                      id="outlined-basic"
                      label="En cours"
                      variant="outlined"
                      required
                      value={encour}
                      onChange={handleChangeEncour}
                    />
                  </Grid>
                  <Grid item xs={4}>
                    <TextField
                      name="Devise"
                      id="outlined-basic"
                      label="Devise"
                      variant="outlined"
                      required
                      value={devise}
                      onChange={handleChangeDevise}
                    />
                  </Grid>
                  <Grid item xs={4}>
                    <TextField
                      name="Délais de maturité"
                      id="outlined-basic"
                      type="date"
                      variant="outlined"
                      required
                      value={delais}
                      onChange={handleChangeMaturityDate}
                    />
                  </Grid>
                </Grid>
                <Grid sx={{ mt: 3 }}>
                  {" "}
                  <center>
                    <Button
                      style={{ background: "#33691e", color: "white" }}
                      type="submit"
                      variant="contained"
                    >
                      {editRow ? "Modifier" : "Ajouter"}
                    </Button>
                  </center>
                </Grid>
              </form>
            </Grid>
          </Grid>
        </Modal>
      </Grid>
    </Grid>
  );
}
