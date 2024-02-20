import React, { useState } from "react";
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
import FilterAltOutlinedIcon from '@mui/icons-material/FilterAltOutlined';
import Paper from "@mui/material/Paper";
import Fab from '@mui/material/Fab';

// components
import Iconify from "../components/iconify";
import Data from "./data.json";

// sections
import {
  AppTasks,
  AppOrderTimeline,
  AppTrafficBySite,
} from "../sections/@dashboard/app";

// ----------------------------------------------------------------------

export default function Chaine() {
  const [value, setValue] = React.useState("1");

  const handleChange = (event, newValue) => {
    setValue(newValue);
  };

  const [openModal, setOpenModal] = useState(false);
  const [selectedNode, setSelectedNode] = useState(null);

  const handleOpenModal = () => setOpenModal(true);
  const handleCloseModal = () => setOpenModal(false);
  const jsondata = Data;

  const graphVizualisation = {
    nodes: [
      { id: 1, label: "500066619", title: "node 1 tootip text" },
      { id: 2, label: "200466619", title: "node 2 tootip text" },
      { id: 3, label: "7111111103", title: "node 3 tootip text" },
      { id: 4, label: "111305861", title: "node 4 tootip text" },
      { id: 5, label: "911305861", title: "node 5 tootip text" },
      { id: 6, label: "400166619", title: "node 1 tootip text" },
      { id: 7, label: "600466619", title: "node 2 tootip text" },
      { id: 8, label: "7158111103", title: "node 3 tootip text" },
      { id: 9, label: "241305861", title: "node 4 tootip text" },
      { id: 10, label: "311305861", title: "node 5 tootip text" },
    ],
    edges: [
      { from: 1, to: 2 },
      { from: 1, to: 3 },
      { from: 2, to: 4 },
      { from: 2, to: 8 },
      { from: 1, to: 5 },
      { from: 1, to: 6 },
      { from: 2, to: 10 },
      { from: 5, to: 10 },
      { from: 8, to: 9 },
      { from: 9, to: 1 },
      { from: 1, to: 7 },
      { from: 6, to: 1 },
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
      width: 1,
      font: { size: 10 },

      smooth: {
        type: "dynamic",
      },
    },
    nodes: {
      shape: "diamond",
      color: "#FA4F00",
      scaling: {
        min: 10,
        max: 30,
      },
      font: {
        size: 10,
        face: "Tahoma",
      },
    },
    height: "500px",
  };

  const eventsV = {
    select(event) {
      const { nodesV, edgesV } = event;
    },
  };


  const nodes = jsondata.map((item) => ({
    id: item.CLI_Emet,
    label: item.CLI_Emet.toString(),
    value: item.MontantXOF,
    title: `MontantXOF: ${item.MontantXOF}`,
  }));

  const edges = jsondata.map((item) => ({
    from: item.CLI_Emet,
    to: item.CLI_S,
    value: item.MontantXOF,
  }));

  const graph = {
    nodes,
    edges,
  };

  const options = {
    layout: {
      hierarchical: false,
    },
    nodes: {
      shape: "dot",
      scaling: {
        customScalingFunction: (min, max, total, value) => {
          return value / (total * 3);
        },
        min: 5,
        max: 150,
      },
      font: {
        size: 14,
      },
      borderWidth: 4,
      color: {
        border: "#73cc7a",
        background: "red",
      },
    },
    edges: {
      color: { color: "#788ede" },
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
    }
  };

  const handleEdgeClick = (event) => {
    const { edges } = event;
    if (edges.length > 0) {
      setSelectedNode(edges[0]);
      // handleOpenModal();
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
              bgcolor: "background.paper",
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
              borderColor: "black",
            }}
          >
            <Paper
              sx={{
                border: 1,
                borderColor: "black",
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
              boxShadow: 7,
              borderRadius: 1,
              border: 1,
              borderColor: "black",
            }}
          >
            <TabContext value={value}>
              <Box sx={{ borderBottom: 1, borderColor: "divider" }}>
                <TabList
                  onChange={handleChange}
                  aria-label="lab API tabs example"
                >
                  <Tab label="Informations" value="1" />
                  <Tab label="graphe de visualisation du voisinage" value="2" />
                </TabList>
              </Box>
              <TabPanel value="1"> Noeud sélectionné: {selectedNode}</TabPanel>
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
