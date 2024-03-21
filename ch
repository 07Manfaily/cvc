function isNumber(value) {
  return typeof value === 'number' && !isNaN(value);
}

{selectedNode ? (
  <>
    <Grid
      container
      direction="column"
      justifyContent="flex-start"
      alignItems="baseline"
    >
      <Typography
        sx={{ mt: -2, mb: 2 }}
        style={{ fontSize: "1.2em" }}
        variant="h6"
        component="div"
      >
        Noeud sélectionné:{" "}
        <b style={{ fontSize: "1em", color: "orange", fontFamily: 'Montserrat' }}>{(node[selectedNode].label).toLowerCase()}</b>{" "}
      </Typography>
      {Object.keys(node[selectedNode])
        .filter((key) => {
          return (
            key !== "Node_ID" &&
            (Object.keys(infoLabel).includes(key) ||
              Object.keys(infoLabel).includes(
                "start".concat(key)
              ))
          );
        })
        .map((key) => {
          let field =
            infoLabel[key] || infoLabel["start".concat(key)];
          field = field.split(" ");
          field = field.slice(0, field.length - 1).join(" ");
          return (
            <Grid
              container
              direction="row"
              justifyContent="space-between"
              alignItems="flex-start"
            >
              <b style={{fontFamily: 'Montserrat'}}>{field.includes("Client SGCI") ? "Type client" : field.includes("NAER") ? "Domaine d'activité" :field.includes("PM") ? "Catégorie":field} </b> 
              <b style={{ fontSize: "1em" , fontFamily: 'Montserrat'}}>
                {key.includes("Node_IS_CLIENT") ? 
                  (node[selectedNode][key] === 1 ? "Interne SGCI" : "Hors SGCI")
                   :key.includes("PM") ? 
                   (node[selectedNode][key] === 1 ? "Personne Morale" : "Personne physique"):
                   isNumber(node[selectedNode][key])
                  ? (Number.isInteger(node[selectedNode][key]) ? fNumber(node[selectedNode][key]) : fPercent(node[selectedNode][key]))
                  : node[selectedNode][key].toLowerCase()}
              </b>
            </Grid>
          );
        })}
    </Grid>
  </>
) : null}



const Max = Math.max(...allValueNode);
  const Min = Math.min(...allValueNode);
  console.log("vaaaaa", allValueNode);
  console.log("vaa max", Max, "vaaa min", Min);
  console.log("SELECt node", selectedNode);

  const nodes = Object.values(node).map((item) => ({
    id: item.id,
    label: item.label,
    value: item.value,
    title: item.value,

    //  value: (item.id ===  parseInt(clusterId.clusterId, 10)) ? 1000000: item.value, //
    color: {
      border:
        item.Node_Provi_Stage_Code === "01"
          ? "lightgreen"
          : item.Node_Provi_Stage_Code === "02"
          ? "orange"
          : item.Node_Provi_Stage_Code === "03"
          ? "red"
          : "black",
          // background : item.Node_IS_CLIENT === 0 ? "gray" : (item.value >1 && item.value <= 1000) ? "#FFE8E8" : item.value === 0 ? "white" : (item.value >1000 && item.value <= 10000) ? "#FACECE" : (item.value >10000 && item.value <= 100000) ? "#FBC0C0" :(item.value >100000 && item.value <= 1000000) ? "#F99191" :(item.value >1000000 && item.value <= 50000000) ? "#F95959":(item.value >50000000 && item.value <= 100000000) ? "#FD4242" :(item.value >100000000 && item.value <= 1000000000) ? "#D10000":(item.value >1000000000) ? "#9C0606":""
     background:  `${NodeColor(item.value, Min, Max)}`,
      // background: (item.startNode_ID === parseInt(clusterId.clusterId, 10)) ? "#7c85f2": (item.startNode_Engagement_XOF > 1e9) ? "#ac0900" :"#e17c77",
    },

import React, { useState, useEffect } from "react";
import axios from "axios";
import { useParams } from "react-router-dom";
import { Helmet } from "react-helmet-async";
import { faker } from "@faker-js/faker";
import { useTheme } from "@mui/material/styles";
import { Grid, Box, Button, Card, Container, Typography } from "@mui/material";
import Accordion from "@mui/material/Accordion";
import AccordionActions from "@mui/material/AccordionActions";
import AccordionSummary from "@mui/material/AccordionSummary";
import AccordionDetails from "@mui/material/AccordionDetails";
import Graph from "react-graph-vis";
import Modal from "@mui/material/Modal";
import Tab from "@mui/material/Tab";
import TabContext from "@mui/lab/TabContext";
import TabList from "@mui/lab/TabList";
import TabPanel from "@mui/lab/TabPanel";
import CircleRoundedIcon from "@mui/icons-material/CircleRounded";
import TripOriginRoundedIcon from "@mui/icons-material/TripOriginRounded";
import ArrowRightAltRoundedIcon from "@mui/icons-material/ArrowRightAltRounded";
import PanoramaFishEyeIcon from "@mui/icons-material/PanoramaFishEye";
import FilterAltOutlinedIcon from "@mui/icons-material/FilterAltOutlined";
import Paper from "@mui/material/Paper";
import Fab from "@mui/material/Fab";
import Tooltip from "@mui/material/Tooltip";
import Table from "@mui/material/Table";
import TableBody from "@mui/material/TableBody";
import TableCell from "@mui/material/TableCell";
import TableContainer from "@mui/material/TableContainer";
import TableHead from "@mui/material/TableHead";
import TableRow from "@mui/material/TableRow";
import Data from "./data.json";
import NodeColor from "../utils/changeColor";
// import Data2 from "./ndata.json";

function createData(Entreprise, Niveau, Montant) {
  return { Entreprise, Niveau, Montant };
}

const rows = [createData("Orange", "S1", 30690000.0)];

export default function Chaine() {
  const [value, setValue] = React.useState("1");

  const handleChange = (event, newValue) => {
    setValue(newValue);
  };

  const [openModal, setOpenModal] = useState(false);
  const [selectedNode, setSelectedNode] = useState(null);
  const [selectedEdge, setSelectedEdge] = useState(null);

  const handleOpenModal = () => setOpenModal(true);
  const handleCloseModal = () => setOpenModal(false);
  const jsondata = Data;

  const [graphe, setGraphe] = useState([]);
  const [node, setNode] = useState([]);
  const [edge, setEdge] = useState([]);
  const [label, setLabel] = useState([]);
  const [error, setError] = useState("");

  const clusterId = useParams();

  useEffect(() => {
    const fetchGraph = async () => {
      try {
        const response = await axios.get(
          `http://localhost:8000/get_neighborhood?FINAL_CLUSTERS=${clusterId.clusterId}`
        );
        console.log("Réponse gaph:", response);

        if (response.status === 200) {
          const data = response.data;
          const dataset = data[Object.keys(data)[0]].value.map((_, line) => {
            const row = {};
            Object.keys(data).forEach((col) => {
              row[col] = data[col].value[line];
            });
            return row;
          });
          const getNode = {};
          dataset.forEach((item) => {
            getNode[item.startNode_ID] = item;
          });

          // const getLabel = dataset.map((item) => item.startNode_NAME);
          // const filterNode = [...new Set(Object.keys(getNode))];
          setGraphe(dataset);
          setNode(Object.values(getNode));
          // setLabel(getLabel);

          console.log("boooo", dataset);
        }
      } catch (error) {
        console.log("Erreur lors du traitement:", error);
        setError("Oups !!!! erreur liée au serveur");
        console.log(
          error.response?.data || "Oups!!!! une erreur s'est produite"
        );
      }
    };

    fetchGraph();
  }, []);


  useEffect(() => {
    const fetchGraphVizualisation = async () => {
      try {
        const response = await axios.get(
          `http://localhost:8000/get_grouping_graph?FINAL_CLUSTERS=${selectedNode.selectedNode}`
        );
        console.log("Réponse du graphe de vouisinnage:", response);

        if (response.status === 200) {
          const data = response.data;
          const dataset = data[Object.keys(data)[0]].value.map((_, line) => {
            const row = {};
            Object.keys(data).forEach((col) => {
              row[col] = data[col].value[line];
            });
            return row;
          });
          const getNode = {};
          dataset.forEach((item) => {
            getNode[item.startNode_ID] = item;
          });

          // const getLabel = dataset.map((item) => item.startNode_NAME);
          // const filterNode = [...new Set(Object.keys(getNode))];
          setGraphe(dataset);
          setNode(Object.values(getNode));
          // setLabel(getLabel);

          console.log("boooo", dataset);
        }
      } catch (error) {
        console.log("Erreur lors du traitement:", error);
        setError("Oups !!!! erreur liée au serveur");
        console.log(
          error.response?.data || "Oups!!!! une erreur s'est produite impossible de recupére le voisignage"
        );
      }
    };

    fetchGraphVizualisation();
  }, []);


  const graphVizualisation = {
    nodes: [
      {
        id: 1,
        label: "Orange\n(CI1234)",
        Iban: "CI1234",
        Clustering_name: "n1",
        Clustering_iban: "i1",
      },
      {
        id: 2,
        label: "Orange mobile\n(CI1234)",
        Iban: "CI1234",
        Clustering_name: "n2",
        Clustering_iban: "i1",
      },
      {
        id: 3,
        label: "Orange company\n(CI3456)",
        Iban: "CI1234",
        Clustering_name: "n3",
        Clustering_iban: "i1",
      },
      {
        id: 4,
        label: "Orange company\n(CI3456)",
        Iban: "CI3456",
        Clustering_name: "n3",
        Clustering_iban: "i2",
      },
      {
        id: 5,
        label: "Orange CI\n(CI3456)",
        Iban: "CI3456",
        Clustering_name: "n4",
        Clustering_iban: "i2",
      },
    ],
    edges: [
      { from: 1, to: 2 },
      { from: 1, to: 3 },
      { from: 2, to: 3 },
      { from: 4, to: 5 },
      { from: 4, to: 3 },
    ],
  };

  const optionsV = {
    interaction: {
      hover: true,
      dragNodes: true,
      tooltipDelay: 20,
      selectable: true,
      navigationButtons: true,
    },

    physics: {
      forceAtlas2Based: {
        gravitationalConstant: -26,
        centralGravity: 0.005,
        springLength: 130,
        springConstant: 0.18,
      },
      stabilization: {
        enabled: true,
        iterations: 1000,
        fit: true,
      },
      maxVelocity: 146,
      solver: "forceAtlas2Based",
      timestep: 0.35,
    },

    configure: {
      enabled: false,
    },
    layout: {
      hierarchical: false,
    },
    edges: {
      arrows: {
        to: { enabled: false },
        from: { enabled: false },
      },
      width: 1,
      font: { size: 10 },

      smooth: {
        type: "dynamic",
      },
    },
    nodes: {
      shape: "oval",
      color: "#007E24",

      scaling: {
        min: 10,
        max: 30,
      },
      font: {
        size: 14,
        face: "Tahoma",
        color: "white",
      },
    },
    height: "500px",
  };

  const eventsV = {
    select(event) {
      const { nodesV, edgesV } = event;
    },
  };
  const allValueNode = [];

  node.map((i) => (
   allValueNode.push(i.endNode_Engagement_XOF)
 ))


 const Maximun = Math.max(...allValueNode)
//  console.log("vaaaaa", allValueNode)
 console.log("SELECt node", selectedNode)

  const nodes = node.map((item) => ({
    id: item.startNode_ID,
    label: item.startNode_NAME,
    value: (item.startNode_ID ===  parseInt(clusterId.clusterId, 10)) ? 1000000: item.startNode_TOTAL_CREDIT, // 
    color: {
      border:
        item.startNode_Provi_Stage_Code === "01"
          ? "lightgreen"
          : item.startNode_Provi_Stage_Code === "02"
          ? "orange"
          : item.startNode_Provi_Stage_Code === "03"
          ? "red"
          : "white",
   background : `rgb(255,${NodeColor(item.startNode_Engagement_XOF, Maximun)},${NodeColor(item.startNode_Engagement_XOF,+Maximun)})`
     // background: (item.startNode_ID === parseInt(clusterId.clusterId, 10)) ? "#7c85f2": (item.startNode_Engagement_XOF > 1e9) ? "#ac0900" :"#e17c77",
    },
    
  }));


  const edges = graphe.map((item) => ({
    from: item.startNode_ID,
    to: item.endNode_ID,
    color:item.startNode_ID === clusterId.clusterId ? "#8c8cff": "#8cc68c"
    //  value:item.edge_RATIO_FLUX_RECU
  }));
  // console.log("nodesss", node); item.startNode_Provi_Stage_Code
// console.log("noeuds select", nodes)
  const graph = {
    nodes,
    edges,
  };

  const options = {
    layout: {
      hierarchical: false,
    },
    nodes: {
      borderWidth: 7,
      borderWidthSelected: 10,
      shape: "dot",
      scaling: {
        customScalingFunction: (min, max, total, value) => {
        //  console.log("VALUE: ", value, "TOTAL: ", total);
          if (value === 1000000) {
            return value/total
          }
          return value / (total * 3);
        },
        // min: 5,
        // max: 150,
      },
      font: {
        size: 12,
        color: "red",
      },
    },
    edges: {
      //  color: { color: "green" }, highlight_from: '#ff0000', highlight_to: '#00ff00'

      color: {
        hover: "black",
        opacity: 1.0,
      },
      smooth: {
        type: "continuous",
      },
      arrows: {
        to: {
          enabled: true,
          scaleFactor: 1,

        },
        from: {
          scaleFactor: 1,
        },
      },
      shadow: false,
    },
    interaction: {
      hover: true,
      dragNodes: true,
      tooltipDelay: 300,
      selectable: true,
      navigationButtons: true,
    },

    physics: {
      forceAtlas2Based: {
        gravitationalConstant: -26,
        centralGravity: 0.005,
        springLength: 130,
        springConstant: 0.18,
      },
      stabilization: {
        enabled: true,
        iterations: 1000,
        fit: true,
      },
      maxVelocity: 146,
      solver: "forceAtlas2Based",
      timestep: 0.35,
    },

    configure: {
      enabled: false,
    },
    height: "1000px",
    width: "1000px",
  };

  const handleNodeClick = (event) => {
    const { nodes } = event;
    if (nodes.length > 0) {
      setSelectedNode(nodes[0]);
      // handleOpenModal();
    } else {
      setSelectedNode(null);
    }
  };

  const handleEdgeClick = (event) => {
    const { edges } = event;
    if (edges.length > 0) {
      setSelectedEdge(edges[0]);

      // handleOpenModal();
    } else {
      setSelectedEdge(null);
    }
  };

  const events = {
    click: handleNodeClick,
    selectEdge: handleEdgeClick,
  };

  return (
    <>
      <Helmet>
        <title> Chaine de valeur </title>
      </Helmet>

      <Grid container spacing={2}>
        <Grid item xs={7} md={7} lg={7}>
          <Box
            sx={{
              // bgcolor: "background.paper",
              bgcolor: "#ddd",
              boxShadow: 7,
              borderRadius: 1,
              border: 1,
              borderColor: "#e7e0e0",
            }}
            id="network"
          >
            <Graph graph={graph} options={options} events={events} />
          </Box>
        </Grid>
        <Grid
          item
          xs={5}
          direction="row"
          justifyContent="flex-start"
          alignItems="flex-start"
        >
          <Box
            sx={{
              flexGrow: 1,
              bgcolor: "background.paper",
              boxShadow: 3,
              borderRadius: 0,
              border: 1,
              borderColor: "#F0F0F0",
            }}
          >
            <Paper
              sx={{
                border: 1,
                borderColor: "#F0F0F0",
                bgcolor: "#FABFBF",
                textAlign: "center",
                borderRadius: 0,
                height: "30px",
              }}
            >
              <h5 style={{ margin: "0", padding: "8px" }}>Légende</h5>
            </Paper>

            <Grid
              container
              direction="column"
              justifyContent="flex-start"
              alignItems="baseline"
            >
              <Grid
                sx={{ pl: 2, mt: 4 }}
                container
                direction="row"
                justifyContent="flex-start"
                alignItems="flex-start"
              >
                <CircleRoundedIcon style={{ color: "red" }} />
                <ArrowRightAltRoundedIcon />
                <CircleRoundedIcon style={{ color: "red" }} />{" "}
                <b style={{ fontSize: "11px" }}>
                  :Client SGCI, plus le rond devient rouge, plus le montant
                  d'engagement est important
                </b>
              </Grid>
              <Grid
                sx={{ pl: 8, mt: 2 }}
                container
                direction="row"
                justifyContent="flex-start"
                alignItems="flex-start"
              >
                <CircleRoundedIcon style={{ color: "gray" }} />

                <b style={{ fontSize: "11px" }}>:Client externe SGCI</b>
              </Grid>

              <Grid
                sx={{ pl: 2, mt: 2 }}
                container
                direction="row"
                justifyContent="flex-start"
                alignItems="flex-start"
              >
                <TripOriginRoundedIcon style={{ color: "green" }} />

                <b style={{ fontSize: "11px" }}>/</b>
                <TripOriginRoundedIcon style={{ color: "yellow" }} />
                <b style={{ fontSize: "11px" }}>/</b>
                <TripOriginRoundedIcon style={{ color: "red" }} />
                <b style={{ fontSize: "11px" }}>
                  : Client S1 / S2 / S3, il s'agit de l'enveloppe extérieur du
                  rond
                </b>
              </Grid>

              <Grid
                sx={{ pl: 2, display: "flex", alignItems: "center" }}
                container
                direction="row"
                justifyContent="flex-start"
              >
                <ArrowRightAltRoundedIcon
                  style={{ color: "#8801CF", fontSize: 25 }}
                />

                <ArrowRightAltRoundedIcon
                  style={{ color: "#8801CF", fontSize: 40 }}
                />
                <ArrowRightAltRoundedIcon
                  style={{ color: "#8801CF", fontSize: 60 }}
                />
                <b style={{ fontSize: "11px" }}>
                  : Flux entrant vers la PM ciblée.plus le montant est important
                  plus le trait du flux est epais
                </b>
              </Grid>

              <Grid
                sx={{ pl: 2, display: "flex", alignItems: "center" }}
                container
                direction="row"
                justifyContent="flex-start"
              >
                <ArrowRightAltRoundedIcon
                  style={{ color: "green", fontSize: 25 }}
                />
                <ArrowRightAltRoundedIcon
                  style={{ color: "green", fontSize: 40 }}
                />
                <ArrowRightAltRoundedIcon
                  style={{ color: "green", fontSize: 60 }}
                />
                <b style={{ fontSize: "11px" }}>
                  : Flux sortant vers la PM ciblée.plus le montant est important
                  plus le trait du flux est epais
                </b>
              </Grid>
              <Grid
                sx={{ pl: 2, display: "flex", alignItems: "center" }}
                container
                direction="row"
                justifyContent="flex-start"
              >
                <PanoramaFishEyeIcon style={{ fontSize: 25 }} />
                <ArrowRightAltRoundedIcon />
                <PanoramaFishEyeIcon style={{ fontSize: 40 }} />
                <b style={{ fontSize: "11px" }}>
                  :Client SGCI, plus le rond devient rouge, plus le montant
                  d'engagement est important
                </b>
              </Grid>
            </Grid>
          </Box>
          <Box
            sx={{
              mt: 4,
              flexGrow: 1,
              bgcolor: "background.paper",
              // boxShadow: 7,
              borderRadius: 1,
              border: 1,
              // borderColor: "black",
            }}
          >
            <TabContext value={value}>
              <Box
                sx={
                  {
                    //  borderBottom: 1,
                    //   borderColor: "divider"
                  }
                }
              >
                <TabList
                  onChange={handleChange}
                  aria-label="lab API tabs example"
                >
                  <Tab label="Informations" value="1" />
                  <Tab label="graphe de visualisation du voisinage" value="2" />
                </TabList>
              </Box>
              <TabPanel value="1">
                {selectedNode ? (
                  <>
                    {/* Noeud sélectionné: {selectedNode}
                    <table style={{ border: " solid black" }}>
                      <tr>
                        <td style={{ border: " solid black" }}>Entreprise</td>
                        <td style={{ border: " solid black" }}>
                          Niveau de risque
                        </td>
                        <td style={{ border: " solid black" }}>Montant</td>
                      </tr>
                      <tr>
                        <td style={{ border: " solid black" }}>Orange</td>
                        <td style={{ border: "solid black" }}>S1</td>
                        <td style={{ border: " solid black" }}>30690000.0</td>
                      </tr>
                    </table> */}
                    <h3>
                      <i>Noeud sélectionné: {selectedNode}</i>
                    </h3>
                    <Table sx={{ minWidth: 50 }} aria-label="simple table">
                      <TableHead>
                        <TableRow>
                          <TableCell>Entreprise</TableCell>
                          <TableCell align="right"> Niveau de risque</TableCell>
                          <TableCell align="right">Montant</TableCell>
                        </TableRow>
                      </TableHead>
                      <TableBody>
                        {rows.map((row) => (
                          <TableRow
                            key={row.Entreprise}
                            sx={{
                              "&:last-child td, &:last-child th": { border: 0 },
                            }}
                          >
                            <TableCell component="th" scope="row">
                              {row.Entreprise}
                            </TableCell>
                            <TableCell align="right">{row.Niveau}</TableCell>
                            <TableCell align="right">{row.Montant}</TableCell>
                          </TableRow>
                        ))}
                      </TableBody>
                    </Table>
                    {/* <table style={{ border: "1px solid black" }}>
    <tr>
        <th style={{ border: "1px solid black" }}>Entreprise</th>
        <td style={{ border: "1px solid black" }}>Orange</td>
    </tr>
    <tr>
        <th style={{ border: "1px solid black" }}>Niveau de risque</th>
        <td style={{ border: "1px solid black" }}>S1</td>
    </tr>
    <tr>
        <th style={{ border: "1px solid black" }}>Montant</th>
        <td style={{ border: "1px solid black" }}>30690000.0</td>
    </tr>
</table> */}
                  </>
                ) : selectedEdge ? (
                  <>
                    {/* Edge sélectionné: {selectedEdge}
                    <table style={{ border: " solid black" }}>
                      <tr>
                        <th style={{ border: " solid black" }}>Emetteur</th>
                        <th style={{ border: " solid black" }}>bénéficiaire</th>
                        <th style={{ border: "solid black" }}>
                          Montant des flux échangés
                        </th>
                      </tr>
                      <tr>
                        <td style={{ border: " solid black" }}>Orange</td>
                        <td style={{ border: " solid black" }}>Moov</td>
                        <td style={{ border: " solid black" }}>
                          305586964690000.0
                        </td>
                      </tr>
                    </table> */}
                    <h3>
                      <i>Edge sélectionné: {selectedEdge}</i>
                    </h3>
                    <Table sx={{ minWidth: 50 }} aria-label="simple table">
                      <TableHead>
                        <TableRow>
                          <TableCell>Emetteur</TableCell>
                          <TableCell align="right"> bénéficiaire</TableCell>
                          <TableCell align="right">
                            {" "}
                            Montant des flux échangés
                          </TableCell>
                        </TableRow>
                      </TableHead>
                      <TableBody>
                        {rows.map((row) => (
                          <TableRow
                            key={row.Entreprise}
                            sx={{
                              "&:last-child td, &:last-child th": { border: 0 },
                            }}
                          >
                            <TableCell component="th" scope="row">
                              {row.Entreprise}
                            </TableCell>
                            <TableCell align="right">{row.Niveau}</TableCell>
                            <TableCell align="right">{row.Montant}</TableCell>
                          </TableRow>
                        ))}
                      </TableBody>
                    </Table>
                  </>
                ) : (
                  "aucune information a affiché"
                )}

                {/* {selectedEdge ? (<>
                
               Edge sélectionné: {selectedEdge}
              <table style={{ border: "1px solid black" }}>
                <tr>
                  <th style={{ border: "1px solid black" }}>Emetteur</th>
                  <th style={{ border: "1px solid black" }}>
                  bénéficiaire
                  </th>
                  <th style={{ border: "1px solid black" }}>Montant des flux échangés</th>
                </tr>
                <tr>
                  <td style={{ border: "1px solid black" }}>Orange</td>
                  <td style={{ border: "1px solid black" }}>Moov</td>
                  <td style={{ border: "1px solid black" }}>305586964690000.0</td>
                </tr>
              </table>
              </>) : "aucune information a affiché"} */}
              </TabPanel>
              <TabPanel value="2">
                <div>
                  <Graph
                    graph={graphVizualisation}
                    options={optionsV}
                    events={eventsV}
                  />
                </div>
              </TabPanel>
            </TabContext>
          </Box>
        </Grid>
        {/* <Fab variant="extended">
        <FilterAltOutlinedIcon />
   
      </Fab> */}
      </Grid>

      {/* <Modal open={openModal} onClose={handleCloseModal}>
        <Box
          sx={{
            position: "absolute",
            top: "50%",
            left: "50%",
            transform: "translate(-50%, -50%)",
            width: 800,
            bgcolor: "background.paper",
            boxShadow: 24,
            p: 4,
          }}
        >
          <h3>Informations</h3>
          <Typography variant="h6" component="h2">
            Noeud sélectionné: {selectedNode}
          </Typography>
          <Button onClick={handleCloseModal}>Fermer</Button>
        </Box>
      </Modal> */}
    </>
  );
}
