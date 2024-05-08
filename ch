useEffect(() => {
    if (alert) {
        toast.warn("Aucune transaction disponible pour ce client veuillez saisir un autre code client !", {
            position: "top-center",
            autoClose: 5000,
            hideProgressBar: false,
            closeOnClick: true,
            pauseOnHover: true,
            draggable: true,
            progress: undefined,
            theme: "dark"
        });
    }
}, [alert]);
import React, { useState, useEffect } from "react";
import DataTable from "react-data-table-component";
import { useNavigate } from "react-router-dom";
import axios from "axios";
import { Card, Stack, Grid, Box, Button } from "@mui/material";
import VisibilityIcon from "@mui/icons-material/Visibility";
import CircleRoundedIcon from "@mui/icons-material/CircleRounded";
import FilterComponent from "../utils/filter";
import { fNumber } from "../utils/formatNumber";
import { Puff} from 'react-loader-spinner';



const Risque = () => {
  const navigate = useNavigate();
  const [client, setClient] = useState([]);
  const [clt, setClt] = useState([]);
  const [error, setError] = useState("");
  const [filterText, setFilterText] = useState("");
  const [resetPaginationToggle, setResetPaginationToggle] = useState(false);
  const [loading, setLoading] = useState(true);


  useEffect(() => {
    const fetchData = async () => {
      try {
        setLoading(true)

        const response = await axios.get("/api/risk/get-clients");
        console.log("Réponse des clients:", response);

        if (response.status === 200) {
          setLoading(false)
          const data = response.data.data;
          const dataset = data[Object.keys(data)[0]].value.map((_, line) => {
            const row = {};
            Object.keys(data).forEach((col) => {
              row[col] = data[col].value[line];
            });
            return row;
          });
           const row = {};
          const d =response.data.data 
          //  const t =   Object.keys(d).map((col) => {
          //  return{ "colo":col }
          // });
          setClient(dataset);
       
          console.log("test", dataset);

          // const clientId = data.CLI_S_SGCI.value;
          // const clusterId = data.FINAL_CLUSTERS.value;
          // const socialRaison = data.NOMREST_S.value;
          // const niveauRisque = data.Provi_Stage_Code.value;
          // const nova = data.NOVA.value;
          // const montantEngagement = data.Engagement_XOF.value;
          // const cA = data.CA_XOF.value;
          // const priority = data.Priority.value;
          // const cellData = [];
          // let i = 0;
          // for (i; i < clientId.length; i += 1) {
          //   const newData = {
          //     CLI_S_SGCI: clientId[i],
          //     FINAL_CLUSTERS: clusterId[i],
          //     NOMREST_S: socialRaison[i],
          //     CA_XOF: cA[i],
          //     Engagement_XOF: montantEngagement[i],
          //     Provi_Stage_Code: niveauRisque[i],
          //     Priority: priority[i],
          //     NOVA: nova[i],
          //   };
          //   cellData.push(row);
          // }

          // });
        }
      } catch (error) {
        setLoading(false)
        console.log("Erreur lors du traitement:", error);
        setError("Oups !!!! erreur liée au serveur");
        console.log(
          error.response?.data || "Oups!!!! une erreur s'est produite"
        );
      }
    };

    fetchData();
  }, []);

  const handleActionClick = (nc, level) => {
    navigate(`/dashboard/chaine-de-valeur/${nc}/${level}`, { replace: true });
  };

  const columns = [
    {
      name: "N° client SGCI",
      selector: (row) => row.CLI_S_SGCI,
      maxWidth: "140px",
    },

    {
      name: "Raison social",
      selector: (row) => row.NOMREST_S,
      maxWidth: "400px",
    },
    {
      name: "Chiffre d’affaires",
      selector: (row) => fNumber(row.CA_XOF),
      maxWidth: "220px",
    },
    {
      name: "Montant des engagements",
      selector: (row) => fNumber(row.Engagement_XOF),
      sortable: true,
      maxWidth: "250px",
    },
    {
      name: "Niveau de risque",
      selector: (row) => {
        if (row.Provi_Stage_Code === "01") {
          return <b>S1</b>;
        } if (row.Provi_Stage_Code === "02") {
          return <b>S2</b>;
        } if (row.Provi_Stage_Code === "03") {
          return <b>S3</b>;
        } if (row.Provi_Stage_Code === "04") {
          return <b>S4</b>;
        }
        return "";
      },
      // selector: (row) => row.Provi_Stage_Code,
      maxWidth: "127px",
    },
    {
      name: "Priorité",
      // selector: (row) => row.Priority,

      selector: (row) => (
        <CircleRoundedIcon style={{ color: `${row.Priority}` }} />
      ),

      maxWidth: "20px",
    },
    {
      name: "Notation NOVA",
      selector: (row) => row.NOVA,
      maxWidth: "119px",
    },
    {
      name: "Action",
      button: true,
      cell: (row) => (
        <Button
          style={{ color: "black" }}
          onClick={() => handleActionClick(row.FINAL_CLUSTERS, 2)}
        >
          <VisibilityIcon style={{ color: "#495F52", fontSize: 30 }} />
        </Button>
      ),
    },
  ];

  const subHeaderComponentMemo = (
    <FilterComponent
      onFilter={(e) => setFilterText(e.target.value)}
      onClear={() => setFilterText("")}
      filterText={filterText}
    />
  );

  const filteredItems = client.filter((item) =>
    Object.values(item).some(
      (value) =>
        typeof value === "string" &&
        value.toLowerCase().includes(filterText.toLowerCase())
    )
  );

  return (
    <>


      {/* <Stack direction="row" justifyContent="space-between" mb={5}>
                <h1>   Liste des clients en dégradation</h1>
              </Stack> */}
      <Card>

        <DataTable
          title="Liste des clients en dégradation"
          columns={columns}
          data={filteredItems}
          progressPending={loading}
          progressComponent={<Puff
            visible={true}
            height="80"
            width="80"
            color="red"
            ariaLabel="puff-loading"
            wrapperStyle={{}}
            wrapperClass=""
          />}
          pagination
          paginationResetDefaultPage={resetPaginationToggle}
          subHeader
          fixedHeader
          fixedHeaderScrollHeight="500px"
          subHeaderComponent={subHeaderComponentMemo}
          persistTableHead
        />
      </Card>
      <Box
        sx={{
          mt: 8,
          bgcolor: "background.paper",
          boxShadow: 7,
          borderRadius: 1,
          border: 1,
          borderColor: "#e7e0e0",
        }}
      >
        <center>
          <b>
            <i>Légende</i>
          </b>
        </center>
        <Grid container sx={{ mt: 4 }}>
          <Grid
            container
            sx={{ mb: 2 }}
            direction="row"
            justifyContent="space-around"
            alignItems="flex-start"
          >
            <Grid justifyContent="flex-start" alignItems="flex-start">
              <CircleRoundedIcon style={{ color: "red" }} />
              <b>Client fortement prioritaire</b>
            </Grid>
            <Grid justifyContent="flex-start" alignItems="flex-start">
              <CircleRoundedIcon style={{ color: "orange" }} />
              <b>Client peu prioritaire</b>
            </Grid>
            <Grid justifyContent="flex-start" alignItems="flex-start">
              <CircleRoundedIcon style={{ color: "green" }} />
              <b>Client moyennement prioritaire</b>
            </Grid>
          </Grid>
        </Grid>
      </Box>



    </>
  );
};

export default Risque;
