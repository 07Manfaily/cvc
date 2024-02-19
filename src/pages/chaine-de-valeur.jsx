import React, { useState } from "react";

import { Helmet } from "react-helmet-async";
import { faker } from "@faker-js/faker";
// @mui
import { useTheme } from "@mui/material/styles";
import { Grid, Box, Button, Card, Container, Typography } from "@mui/material";
import Accordion from "@mui/material/Accordion";
import AccordionActions from "@mui/material/AccordionActions";
import AccordionSummary from "@mui/material/AccordionSummary";
import AccordionDetails from "@mui/material/AccordionDetails";
import ExpandMoreIcon from "@mui/icons-material/ExpandMore";
import Graph from "react-graph-vis";
import Modal from "@mui/material/Modal";
import CardHeader from "@mui/material/CardHeader";
import CardContent from "@mui/material/CardContent";
import CardActions from "@mui/material/CardActions";
import CircleRoundedIcon from "@mui/icons-material/CircleRounded";
import TripOriginRoundedIcon from "@mui/icons-material/TripOriginRounded";
import ArrowRightAltRoundedIcon from "@mui/icons-material/ArrowRightAltRounded";
import legende from "../utils/legende.png";

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
  const [openModal, setOpenModal] = useState(false);
  const [selectedNode, setSelectedNode] = useState(null);

  const handleOpenModal = () => setOpenModal(true);
  const handleCloseModal = () => setOpenModal(false);
  const jsondata = Data;

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
      handleOpenModal();
    }
  };

  const handleEdgeClick = (event) => {
    const { edges } = event;
    if (edges.length > 0) {
      setSelectedNode(edges[0]);
      handleOpenModal();
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
        <Grid item xs={6} md={6} lg={8}>
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
        <Grid item xs={4}>
          <Box>
            <h1>fdfdf</h1>
          </Box>
        </Grid>
      </Grid>

      <Modal open={openModal} onClose={handleCloseModal}>
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
      </Modal>
    </>
  );
}
