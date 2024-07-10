Would you like to run the app on another port instead? ... yes
(node:25492) [DEP_WEBPACK_DEV_SERVER_ON_AFTER_SETUP_MIDDLEWARE] DeprecationWarning: 'onAfterSetupMiddleware' option is deprecated. Please use the 'setupMiddlewares' option.
(Use `node --trace-deprecation ...` to show where the warning was created)
(node:25492) [DEP_WEBPACK_DEV_SERVER_ON_BEFORE_SETUP_MIDDLEWARE] DeprecationWarning: 'onBeforeSetupMiddleware' option is deprecated. Please use the 'setupMiddlewares' option.








import React, { useState, useEffect } from "react";
import axios from "axios";
import { useParams } from "react-router-dom";
import { Vortex } from 'react-loader-spinner';
import { Comment } from 'react-loader-spinner';
import { ThreeCircles } from 'react-loader-spinner';
import { Grid, Box, Divider, Button, Typography, Drawer, Slider, Stack } from "@mui/material";
import Graph from "react-graph-vis";
import Modal from "@mui/material/Modal";
import { getCookie } from '../utils/getCookies'
import Tab from "@mui/material/Tab";
import TabContext from "@mui/lab/TabContext";
import TabList from "@mui/lab/TabList";
import TabPanel from "@mui/lab/TabPanel";
import CircleRoundedIcon from "@mui/icons-material/CircleRounded";
import TripOriginRoundedIcon from "@mui/icons-material/TripOriginRounded";
import ArrowRightAltRoundedIcon from "@mui/icons-material/ArrowRightAltRounded";
import PanoramaFishEyeIcon from "@mui/icons-material/PanoramaFishEye";
import Paper from "@mui/material/Paper";
import TextField from '@mui/material/TextField';
import Checkbox from '@mui/material/Checkbox';
import SpeakerNotesIcon from "@mui/icons-material/SpeakerNotes";
import Accordion from "@mui/material/Accordion";
import ThumbUpAltIcon from '@mui/icons-material/ThumbUpAlt';
import ThumbDownIcon from '@mui/icons-material/ThumbDown';
import AccordionSummary from "@mui/material/AccordionSummary";
import AccordionDetails from "@mui/material/AccordionDetails";
import Iconify from '../components/iconify';
import ExpandMoreIcon from "@mui/icons-material/ExpandMore";
import Radio from '@mui/material/Radio';
import SendIcon from '@mui/icons-material/Send';
import Alert from '@mui/material/Alert';
import { formatKeyResponse } from '../utils/formatResponse';
import MenuItem from '@mui/material/MenuItem';
import FormControl from '@mui/material/FormControl';
import Select from '@mui/material/Select';
import InputLabel from '@mui/material/InputLabel';
import OutlinedInput from '@mui/material/OutlinedInput';
import IconButton from '@mui/material/IconButton';
import InfoIcon from '@mui/icons-material/Info';
import FilterAltTwoToneIcon from '@mui/icons-material/FilterAltTwoTone';
import FilterAltOffTwoToneIcon from '@mui/icons-material/FilterAltOffTwoTone';
import HighlightOffTwoToneIcon from '@mui/icons-material/HighlightOffTwoTone';
import StarBorderPurple500Icon from '@mui/icons-material/StarBorderPurple500';
import Scrollbar from '../components/scrollbar';


// import Data2 from "./ndata.json"; 


export default function RiskChaine() {
  const style = {
    position: "absolute",
    top: "50%",
    left: "50%",
    transform: "translate(-50%, -50%)",
    width: 1000,
    bgcolor: "background.paper",
    border: "2px solid #000",
    boxShadow: 24,
    p: 4,
  };


  const [openGrid, setOpenGrid] = useState(false);
  const handleCloseGrid = () => {
    setOpenGrid(false);
  };

  const [opens, setOpens] = React.useState(false);
  const handleOpens = () => setOpens(true);
  const handleCloses = () => setOpens(false);


  const [openL, setOpenL] = React.useState(false);
  const handleOpenL = () => setOpenL(true);
  const handleCloseL = () => setOpenL(false);

  const [value, setValue] = React.useState("1");

  const handleChange = (event, newValue) => {
    setValue(newValue);
  };

  const handleChangeComment1 = (event) => {
    setComment1(event.target.value);
  };

  const handleChangeComment2 = (event) => {
    setComment2(event.target.value);
  };

  const handleChangeLevel = (event) => {
    setLevel(event.target.value);
  };


  const handleChangeDirection = (event) => {
    setDirection(event.target.value);
  };

  const handleChangeWeight = (event) => {

    setWeight(event.target.value);

  };
  const handleChangeRiskCategory = (event) => {
    setRiskCategory([...riskCategory, event.target.value]);
  };
  const handleChangeSlide = (event) => {
    setSlide(event.target.value);
  };

  const [level, setLevel] = useState(2);
  const [open, setOpen] = useState(false);
  const [loading, setLoading] = useState(false);
  const [loadvisualization, setLoadvisualization] = useState(false);
  const [loadComment, setLoadComment] = useState(false);
  const handleOpen = () => setOpen(true);
  const handleClose = () => setOpen(false);
  const [selectedNode, setSelectedNode] = useState(null);
  const [selectedEdge, setSelectedEdge] = useState(null);
  const [infoLabel, setInfoLabel] = useState([]);
  const [graphe, setGraphe] = useState([]);
  const [node, setNode] = useState([]);
  const [graphevoisinage, setGrapheVoisinage] = useState([]);
  const [error, setError] = useState("");
  const [errorComment, setErrorComment] = useState("");
  const [errorVisualisation, setErrorVisualisation] = useState("Veillez cliqué sur un noeud pour visualisé le voisinage");
  const [explicability, setExplicability] = useState([]);
  const [response1, setResponse1] = useState(0);
  const [response2, setResponse2] = useState(0);
  const [response3, setResponse3] = useState(0);
  const [response4, setResponse4] = useState(0);
  const [response5, setResponse5] = useState(0);
  const [comment1, setComment1] = useState("");
  const [comment2, setComment2] = useState("");
  const [weight, setWeight] = React.useState(1)
  const [direction, setDirection] = React.useState(1);
  const [riskCategory, setRiskCategory] = React.useState([]);
  const [slide, setSlide] = React.useState(1);


  const handleResponse1 = (event) => {
    setResponse1(event.target.value);
  }
  const handleResponse2 = (event) => {
    setResponse2(event.target.value);
  }
  const handleResponse3 = (event) => {
    setResponse3(event.target.value);
  }
  const handleResponse4 = (event) => {
    setResponse4(event.target.value);
  }
  const handleResponse5 = (event) => {
    setResponse5(event.target.value);
  }

  const sendCommentary = async () => {
    try {
      setLoadComment(true)
      const response = await axios.post("/api/risk/set-analyse-comment",
        {
          final_cluster: clusterId.clusterId,
          quiz1: response1,
          quiz2: response2,
          quiz3: response3,
          quiz4: response4,
          quiz5: response5,
          comment1: comment1,
          comment2: comment2
        },
        {
          headers: {
            'Content-Type': 'application/json',
          }
        }
      );
      if (response.status === 200) {
        setLoadComment(false)
        setErrorComment("Commentaire envoyé avec succès")
        setResponse1(0)
        setResponse2(0)
        setResponse3(0)
        setResponse4(0)
        setResponse5(0)
      }
      console.log("reponse", response)
    }
    catch (error) {
      console.log("Erreur lors du traitement:", error);
      setError(error.message);
    }
  }

  const clusterId = useParams();
      //  `/api/risk/get-neighborhood?FINAL_CLUSTERS=${clusterId.clusterId}&depth=${level}`

  const fetchGraph = async () => {
    try {
      handleCloses()
      setLoading(true)
      const response = await axios.post(
      "/api/risk/get-neighborhood",
      {
        "FINAL_CLUSTERS":  clusterId.clusterId,
        "depth":  level,
        "ftop_value":   weight ? 0 : 1,
        "ftransaction_weight":  weight ? 1 : 0,
        "fvalue":  slide,
        "risk_category": riskCategory
    },
    {
      headers: {
          'Content-Type': 'application/json',
          'X-CSRF-TOKEN': getCookie("csrf_refresh_token")
      }
  },
      );
      console.log("Réponse gaph:", response);


      if (response.status === 201) {
        setError("Désolé aucun client trouvé")
      }

      if (response.status === 200) {
        setLoading(false)

        const data = response.data.data;
        const infoLabel = {};
        Object.keys(data).forEach((k) => {
          infoLabel[k] = data[k].name;
        });
        setInfoLabel(infoLabel);

        const dataset = data[Object.keys(data)[0]].value.map((_, line) => {
          const row = {};
          Object.keys(data).forEach((col) => {
            row[col] = data[col].value[line];
          });
          return row;
        });
        const getNode = {};
        dataset.forEach((rel) => {
          rel["depth"] = -1;
          ["start", "end"].forEach((direction) => {
            const _id = rel[`${direction}Node_ID`];
            if (!Object.keys(getNode).includes(_id)) {
              getNode[_id] = {
                id: _id,
                value: rel[`${direction}Node_Engagement_XOF`],
                title: rel[`${direction}Node_NAME`],
                label: rel[`${direction}Node_NAME`],
              };
              Object.keys(rel).forEach((key) => {
                if (key.startsWith(direction)) {
                  getNode[_id][key.split(direction)[1]] = rel[key];
                }
              });
            }
          });
        });
        // dataset.forEach((item) => {
        //   getNode[item.startNode_ID] = item;

        // });
        let node_connected_to_root = new Set([parseInt(clusterId.clusterId)]);
        [..."_".repeat(level)].forEach((_, index) => {
          dataset.filter((rel) => node_connected_to_root.has(parseInt(rel.startNode_ID)) && rel.depth === -1).forEach((rel) => {
            rel["depth"] = index + 1;
            node_connected_to_root.add(parseInt(rel.endNode_ID));
          })
        });
        console.log("node_connected_to_root:", node_connected_to_root)
        console.log("final_dataset to graph:", dataset);
        setGraphe(dataset);
        setNode(getNode);
        // setLabel(getLabel);

        console.log("boooo", dataset);
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
  const fetchGraphVizualisation = async () => {
    try {
      setLoadvisualization(true)
      const response = await axios.get(
        `/api/risk/get-grouping-graph?FINAL_CLUSTERS=${selectedNode}`
      );
      console.log("Réponse du graphe de vouisinnage:", response);


      if (response.status === 200) {
        const data = response.data.data;
        setGrapheVoisinage(data);
        setLoadvisualization(false)

        console.log("voisinage", data)
        // setNodeVoisinage(Object.values(getNodeVoisinage));

        //  console.log(" groupage", dataVoisinage);
      }
      if (response.status === 201) {
        setGrapheVoisinage([]);
        setLoadvisualization(false)
        setErrorVisualisation("désolé il n'y as pas de voisinage associé a cet element")
      }

    } catch (error) {
      console.log("Erreur lors du traitement:", error);
      setErrorVisualisation("Oups !!!! erreur liée au serveur");
      console.log(
        error.response?.data ||
        "Oups!!!! une erreur s'est produite impossible de recupére le voisignage"
      );
    }
  };
  // useEffect(() => {
  //   fetchGraph()
  // }, [level, openGrid])

  useEffect(() => {
    if (selectedNode) {
      fetchGraphVizualisation();
    }
  }, [selectedNode]);
  const fetchExplainability = async () => {
    try {
      const response = await axios.get(
        `/api/risk/get_explainability?FINAL_CLUSTERS=${clusterId.clusterId}`
      );

      if (response.status === 200) {
        setExplicability(response.data.data);
      }
    } catch (error) {
      console.log("Erreur lors du traitement:", error);
      setError("Oups !!!! erreur liée au serveur");
      console.log(
        error.response?.data || "Oups!!!! une erreur s'est produite"
      );
    }
  };

  useEffect(() => {
    if (explicability) { fetchExplainability(); }

  }, []);
  // Création d'un objet pour regrouper les entreprises par IBAN ou CLUSTERING_NAME

  // Création des noeuds pour chaque entreprise unique
  const nodesVoisinage = graphevoisinage.map((e, i) => ({
    id: i,
    label: `${e.Name} (${e.IBAN})`,
    shape: "dot",
    color: "#C75A00",

  }));

  // Création des aretes entre les noeuds ayant le mme CLUSTERING_IBAN ou CLUSTERING_NAME
  const edgesVoisinage = [];
  graphevoisinage.forEach((node, _id) => {
    graphevoisinage.forEach((compare_node, _id_compare) => {
      if (_id > _id_compare && (node.CLUSTERING_IBAN === compare_node.CLUSTERING_IBAN || node.CLUSTERING_NAME === compare_node.CLUSTERING_NAME))
        edgesVoisinage.push({ from: _id, to: _id_compare });
    })
  });

  const graphVizualisation = {
    nodes: nodesVoisinage,
    edges: edgesVoisinage,
  };

  const optionsV = {
    interaction: {
      hover: true,
      dragNodes: true,
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
        type: "continuous",
      },
    },
    nodes: {
      // scaling: {
      //   min: 10,
      //   max: 30,
      // },
      font: {
        size: 10,
        face: "Tahoma",
        color: "black",
      },
    },
    height: "500px",
  };

  const allValueNode = [];
  Object.values(node).map((i) => allValueNode.push(i.value));
  const Max = Math.max(...allValueNode);
  const Min = Math.min(...allValueNode);
  const nodes = Object.values(node).map((item) => ({
    id: item.id,
    label: item.label,
    value: item.value,
    title: item.value,
    shape: item.id === parseInt(clusterId.clusterId, 10) ? "star" : "dot",
    //  value: (item.id ===  parseInt(clusterId.clusterId, 10)) ? 1000000: item.value, //
    color: {
      border:
        item.Node_Provi_Stage_Code === "01"
          ? "lightgreen"
          : item.Node_Provi_Stage_Code === "02"
            ? "orange"
            : item.Node_Provi_Stage_Code === "03"
              ? "red"
              : item.Node_IS_CLIENT === 0
                ? "gray"
                : "#ddd",
      background:
        item.Node_IS_CLIENT === 0
          ? "gray"
          : item.value > 1 && item.value <= 1000
            ? "#FFE8E8"
            : item.value === 0
              ? "#FFEBEB"
              : item.value > 1000 && item.value <= 10000
                ? "#FACECE"
                : item.value > 10000 && item.value <= 100000
                  ? "#FBC0C0"
                  : item.value > 100000 && item.value <= 1000000
                    ? "#F99191"
                    : item.value > 1000000 && item.value <= 50000000
                      ? "#F95959"
                      : item.value > 50000000 && item.value <= 100000000
                        ? "#FD4242"
                        : item.value > 100000000 && item.value <= 1000000000
                          ? "#D10000"
                          : item.value > 1000000000
                            ? "#9C0606"
                            : "",
      // background:  NodeColor(item.value, Min, Max),
      // background: (item.startNode_ID === parseInt(clusterId.clusterId, 10)) ? "#7c85f2": (item.startNode_Engagement_XOF > 1e9) ? "#ac0900" :"#e17c77",
    },
  }));

  const edges = graphe.map((item) => {

    return {
      from: item.startNode_ID,
      to: item.endNode_ID,
      // length:item.edge_TOTAL_FLUX/2500000,
      //  value: item.edge_TOTAL_FLUX,
      value:
        item.depth > 0
          ? item.edge_RATIO_FLUX_EMIS
          : item.edge_RATIO_FLUX_RECU,
      color:
        item.depth > 0
          ? "#009E3A"
          : "#0081B9",
      ...item,
      //  value:item.edge_RATIO_FLUX_RECU
    }
  });
  // console.log("nodesss", node); item.startNode_Provi_Stage_Code

  const graph = {
    nodes,
    edges,
  };

  const options = {
    layout: {
      hierarchical: false,
    },
    nodes: {
      borderWidth: 4,
      borderWidthSelected: 10,

      // scaling: {
      //   customScalingFunction: (min, max, total, value) => {
      //     let result = 0;
      //     if (value) {
      //       result = value / total;
      //       return result;
      //     }

      //     return result;

      //     // const scale = 1 / (max - min);
      //     // return Math.max(0,(value - min)*scale);
      //   },
      //   min: 10,
      //   max: 70,
      // },

      //  scaling:{
      //   min: 10,
      //    max: 150,
      //   },
      // },
      scaling: {
        customScalingFunction: (min, max, total, value) => {
          //  console.log("VALUEl: ", value, "TOTAlL: ", total);
          if (value) {
            return value / total;
          }
          return "";
          // return value / (total * 3);
        },
        //  min: 10,
        //  max: 60,
      },

      font: {
        size: 12,
        color: "black",
      },
    },

    edges: {
      color: {
        hover: "black",
        opacity: 1.0,
      },

      scaling: {
        min: 1,
        max: 20,
        // label: {
        //   enabled: true,
        //   min: 14,
        //   max: 30,
        //   maxVisible: 30,
        //   drawThreshold: 5
        // },
      },
      // smoothCurves:{
      //   type:true
      // },
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
    // tooltip: {
    //   delay: 300,
    //   fontColor: "black",
    //   fontSize: 14, // px
    //   fontFace: "verdana",
    //   color: {
    //     border: "#666",
    //     background: "#FFFFC6",
    //   },
    // },
    physics: {

      forceAtlas2Based: {
        gravitationalConstant: -60,
        centralGravity: 0.009,
        springLength: 200,
        springConstant: 0.38,

      },
      stabilization: {
        enabled: true,
        iterations: 10,
        fit: true,
      },
      maxVelocity: 14,
      solver: "forceAtlas2Based",
      timestep: 2,
    },

    configure: {
      enabled: false,
    },
    // height: "1000px",
    // width: "1000px",
  };

  const handleNodeClick = (event) => {
    const { nodes } = event;
    if (nodes.length > 0) {
      setOpenGrid(true)

      setSelectedNode(nodes[0]);

      // handleOpenModal();
    } else {
      setSelectedNode(null);
    }
  };
  console.log(
    "noeud selectionné event",
    selectedNode,
    "node croche",
    node[selectedNode]
  );
  // if (selectedNode != null) {
  //   for (
  //     let index = 0;
  //     index < Object.keys(node[selectedNode]).length;
  //     index += 1
  //   ) {
  //     const key = Object.keys(node[selectedNode])[index];
  //     const str = "start";
  //     if (
  //       key !== "Node_ID" &&
  //       (Object.keys(infoLabel).includes(key) ||
  //         Object.keys(infoLabel).includes(str + key))
  //     ) {
  //       let field = infoLabel[key] || infoLabel[str + key];
  //       field = field.split(" ");
  //       field = field.slice(0, field.length - 1).join(" ");
  //       console.log(key, "field:", field, "value:", key === "Node_IS_CLIENT" ? (node[selectedNode][key] === 1 ? "client interne" : "client externe") : node[selectedNode][key]);
  //     }
  //   }
  // }
  const handleEdgeClick = (event) => {
    const edge = event.edges;
    if (edge.length > 0) {
      setOpenGrid(true)
      setSelectedEdge(edges.filter((_edge) => _edge.id === edge[0])[0]);
    } else {
      setSelectedEdge(null);
    }
  };
  console.log("edge selectionné", selectedEdge);

  const events = {
    click: handleNodeClick,
    selectEdge: handleEdgeClick,
  };
  return (
    <>
      <Grid container spacing={2}>
        <Grid item xs={openGrid ? 7 : 12} md={openGrid ? 7 : 12} lg={openGrid ? 7 : 12}>
          
          
        <Drawer

            anchor="top"
            open={openL}
            onClose={handleCloseL}
            PaperProps={{
              sx: {left:'calc(100% / 2 - (100% / 6))', width: 'calc(100% / 3)', border: 'none', overflow: 'hidden' },
            }}
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
                mt: 4,
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
                <CircleRoundedIcon style={{ color: "#F59494" }} />
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
                <StarBorderPurple500Icon />

                <b style={{ fontSize: "11px" }}>:Client sélectionné</b>
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
                <TripOriginRoundedIcon style={{ color: "lightgreen" }} />

                <b style={{ fontSize: "11px" }}>/</b>
                <TripOriginRoundedIcon style={{ color: "orange" }} />
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
                  style={{ color: "#009E3A", fontSize: 25 }}
                />

                <ArrowRightAltRoundedIcon
                  style={{ color: "#009E3A", fontSize: 40 }}
                />
                <ArrowRightAltRoundedIcon
                  style={{ color: "#009E3A", fontSize: 60 }}
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
                  style={{ color: "#0081B9", fontSize: 25 }}
                />
                <ArrowRightAltRoundedIcon
                  style={{ color: "#0081B9", fontSize: 40 }}
                />
                <ArrowRightAltRoundedIcon
                  style={{ color: "#0081B9", fontSize: 60 }}
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
                  :importance des flux totaux créditeurs de la PM. Plus le
                  montant des flux reçus par <br />
                  la PM est important, plus la taille du rond est grande
                </b>
              </Grid>
            </Grid>
            </Box>
          </Drawer>
          
          <Drawer
            anchor="right"
            open={opens}
            onClose={handleCloses}
            PaperProps={{
              sx: { width: 370, border: 'none', overflow: 'hidden' },
            }}
          >
            <Stack direction="row" alignItems="center" justifyContent="space-between" sx={{ px: 1, py: 2 }}>
              <Typography variant="subtitle1" sx={{ ml: 1 }}>
                Paramettre de recherche
              </Typography>
              <IconButton onClick={handleClose}>
                <Iconify icon="eva:close-fill" />
              </IconButton>
            </Stack>

            <Divider />

            <Scrollbar>
              <Stack spacing={8} sx={{ p: 3 }}>


                <TextField sx={{ minWidth: 270 }}
                  fullWidth label="Code client"
                  id="fullWidth"
                  size="small"
                  disabled="true"
                  value={clusterId.clusterId}
                />

                <Grid >
                  <p>Type client</p>
                  <Grid container
                    direction="row"
                    justifyContent="space-evenly"
                    alignItems="flex-start">
                    <b>S1 <Checkbox onChange={handleChangeRiskCategory} value={1} color="success" /></b>
                    <b>S2 <Checkbox onChange={handleChangeRiskCategory} value={2} color="warning" /></b>
                    <b>S3 <Checkbox onChange={handleChangeRiskCategory} value={3} color="error" /></b>
                    <b>hors <Checkbox onChange={handleChangeRiskCategory} value={4} style={{ color: "gray" }} /></b>

                  </Grid>
                </Grid>

                <FormControl sx={{ m: 1, minWidth: 270 }} size="small">
                  <InputLabel id="demo-select-small-label">Type d'opération</InputLabel>
                  <Select
                    labelId="demo-select-small-label"
                    id="demo-select-small"
                    value={direction}
                    label="Age"
                    onChange={handleChangeDirection}
                  >
                    <MenuItem value={1}>Credit</MenuItem>
                    <MenuItem value={-1}>Debit</MenuItem>
                  </Select>
                </FormControl>


                <FormControl sx={{ m: 1, minWidth: 270 }} size="small">
                  <InputLabel id="demo-select-small-label">Profondeur</InputLabel>
                  <Select
                    labelId="demo-select-small-label"
                    id="demo-select-small"
                    value={level}
                    label="Niveau"
                    onChange={handleChangeLevel}
                  >
                    <MenuItem value={1}>Niveau1</MenuItem>
                    <MenuItem value={2}>Niveau2</MenuItem>
                    <MenuItem value={3}>Niveau3</MenuItem>
                    <MenuItem value={4}>Niveau4</MenuItem>

                  </Select>
                </FormControl>


                <FormControl sx={{ m: 1, minWidth: 270 }} size="small">
                  <InputLabel id="demo-select-small-label">Poids de la transaction</InputLabel>

                  <Select
                    labelId="demo-select-small-label"
                    id="demo-select-small"
                    value={weight}
                    label="Niveau"
                    onChange={handleChangeWeight}
                  >
                    <MenuItem value={1}>Poids de la transaction</MenuItem>
                    <MenuItem value={0}>Top valeur</MenuItem>
                  </Select>
                </FormControl>



                <Box> <Typography id="non-linear-slider" gutterBottom>

                  Valeur: <b style={{ color: "#09954A" }}><i>{slide} {weight === 1 ? "%" : ""}</i></b>
                </Typography><Slider sx={{ height: 40, color: "black" }}
                  defaultValue={1}
                  marks
                  min={1}
                  onChange={handleChangeSlide}
                  value={slide}
                  max={100} aria-label="Default" valueLabelDisplay="auto" />
                </Box>


                <Button onClick={fetchGraph} style={{ backgroundColor: '#000000', width: 300 }} variant="contained" endIcon={<SendIcon />}>
                  <b style={{ color: "red" }}>Lancer</b>
                </Button>
              </Stack>
            </Scrollbar>





          </Drawer>

          <Box
            sx={{
              // bgcolor: "background.paper",
              bgcolor: "#ddd",
              boxShadow: 7,
              borderRadius: 1,
              border: 1,
              borderColor: "#e7e0e0",
              height: "100vh"
            }}
            id="network"
          >
            <Grid
              container
              direction="row"
              justifyContent="flex-end"
              alignItems="flex-start"
              style={{ position: "fixed", top: 'calc(100% / 7)', right: 'calc(100% / 35)', zIndex: 100 }}
            >
              {" "}
              <Button onClick={handleOpenL} style={{ backgroundColor: "green" }} variant="contained" >
                <InfoIcon
                  style={{ color: "white" }} />
              </Button>
              <Button sx={{ ml: 2 }} onClick={handleOpen} style={{ backgroundColor: "#070755" }} variant="contained" >
                <SpeakerNotesIcon style={{ color: "white" }} />
              </Button>
           
              <Button sx={{ ml: 2 }} variant="contained" style={{ backgroundColor: "black" }} onClick={handleOpens}>
                {open ? <FilterAltOffTwoToneIcon style={{ color: "red" }} /> : <FilterAltTwoToneIcon style={{ color: "red", fontSize: 25 }} />}
              </Button>
              {/* <Fab sx={{

                mr: 2
              }} onClick={handleOpens} variant="extended">
                <SettingsIcon style={{ color: "red" }} />
              </Fab> */}


              {/* Modal for commentary */}
              <Modal
                open={open}
                onClose={handleClose}
                aria-labelledby="modal-modal-title"
                aria-describedby="modal-modal-description"
              >
                <Box sx={style}>
                  <center>
                    <Typography
                      id="modal-modal-title"
                      variant="h6"
                      component="h2"
                    >
                      Veuillez repondre a cette enquête!!
                    </Typography>
                    {loadComment ?
                      <Comment
                        visible={true}
                        height="80"
                        width="40"
                        ariaLabel="comment-loading"
                        wrapperStyle={{}}
                        wrapperClass="comment-wrapper"
                        color="#fff"
                        backgroundColor="#00982A"
                      /> : errorComment ? (
                        <Alert variant="outlined" severity="success">
                          <b><h3> {errorComment}</h3></b>
                        </Alert>
                      ) :
                        ''
                    }
                  </center>

                  <Grid
                    sx={{ mt: 7 }}
                    container
                    direction="column"
                    justifyContent="space-between"
                    alignItems="flex-start"
                  >
                    <Grid container
                      direction="row"
                      justifyContent="space-between" alignItems="flex-start">
                      <b style={{
                        fontFamily: "math"
                      }}>Les données affichées sont-elles exactes ?</b>
                      <Grid>

                        <Radio
                          style={{ color: "green" }}
                          checked={response1 === "1"}
                          onChange={handleResponse1}
                          value="1"
                          name="radio-buttons"
                        />
                        <ThumbUpAltIcon style={{ color: "green" }} />
                        <Radio style={{ color: "red" }}
                          checked={response1 === "0"}
                          onChange={handleResponse1}
                          value="0"
                          name="radio-buttons"
                        /><ThumbDownIcon style={{ color: "red" }} /></Grid>
                    </Grid>
                    {
                      response1 === "0" ?
                        <FormControl fullWidth sx={{ m: 1 }}>
                          <InputLabel htmlFor="outlined-adornment-amount">Commentaire</InputLabel>
                          <OutlinedInput
                            id="outlined-adornment-amount"
                            label="Ajouter un commentaire"
                            value={comment1}
                            onChange={handleChangeComment1}
                          />
                        </FormControl>
                        :
                        ""}
                    <Grid sx={{ mt: 2 }} container
                      direction="row"
                      justifyContent="space-between" alignItems="flex-start">


                      <b style={{
                        fontFamily: "math"
                      }}>Y a-t-il une information complémentaire dont vous auriez besoin et qui n'est pas présente ?</b>
                      <Grid> <Radio
                        style={{ color: "green" }}
                        checked={response2 === "1"}
                        onChange={handleResponse2}
                        value="1"
                        name="radio-buttons"
                      />
                        <ThumbUpAltIcon style={{ color: "green" }} />
                        <Radio style={{ color: "red" }}
                          checked={response2 === "0"}
                          onChange={handleResponse2}
                          value="0"
                          name="radio-buttons"
                        /><ThumbDownIcon style={{ color: "red" }} /></Grid>
                    </Grid>
                    {
                      response2 === "0" ?
                        <FormControl fullWidth sx={{ m: 1 }}>
                          <InputLabel htmlFor="outlined-adornment-amount">Commentaire</InputLabel>
                          <OutlinedInput
                            id="outlined-adornment-amount"
                            label="Ajouter un commentaire"
                            value={comment2}
                            onChange={handleChangeComment2}
                          />
                        </FormControl>
                        :
                        ""}
                    <Grid sx={{ mt: 2 }} container
                      direction="row"
                      justifyContent="space-between" alignItems="flex-start">


                      <b style={{
                        fontFamily: "math"
                      }}>Les zones d'investigations recommandées (onglet Explicabilité) sont-elles pertinentes ?</b>
                      <Grid> <Radio
                        style={{ color: "green" }}
                        checked={response3 === "1"}
                        onChange={handleResponse3}
                        value="1"
                        name="radio-buttons"
                      />
                        <ThumbUpAltIcon style={{ color: "green" }} />
                        <Radio style={{ color: "red" }}
                          checked={response3 === "0"}
                          onChange={handleResponse3}
                          value="0"
                          name="radio-buttons"
                        /><ThumbDownIcon style={{ color: "red" }} /></Grid>
                    </Grid>
                    <Grid sx={{ mt: 2 }} container
                      direction="row"
                      justifyContent="space-between" alignItems="flex-start">


                      <b style={{
                        fontFamily: "math"
                      }}>Le client est-il catégorisé en rouge/orange alors qu'il n'y a pas d'éléments particuliers à creuser ?</b>
                      <Grid>
                        <Radio
                          style={{ color: "green" }}
                          checked={response4 === "1"}
                          onChange={handleResponse4}
                          value="1"
                          name="radio-buttons"
                        />
                        <ThumbUpAltIcon style={{ color: "green" }} />
                        <Radio style={{ color: "red" }}
                          checked={response4 === "0"}
                          onChange={handleResponse4}
                          value="0"
                          name="radio-buttons"
                        /><ThumbDownIcon style={{ color: "red" }} />
                      </Grid>
                    </Grid>
                    <Grid sx={{ mt: 2 }} container
                      direction="row"
                      justifyContent="space-between" alignItems="flex-start">


                      <b style={{
                        fontFamily: "math"
                      }}>Le client est-il catégorisé en vert alors qu'il y a des éléments à creuser ?</b>
                      <Grid>
                        <Radio
                          style={{ color: "green" }}
                          checked={response5 === "1"}
                          onChange={handleResponse5}
                          value="1"
                          name="radio-buttons"
                        />
                        <ThumbUpAltIcon style={{ color: "green" }} />
                        <Radio style={{ color: "red" }}
                          checked={response5 === "0"}
                          onChange={handleResponse5}
                          value="0"
                          name="radio-buttons"
                        /><ThumbDownIcon style={{ color: "red" }} />
                      </Grid>
                    </Grid>
                  </Grid>
                  <center> <Button onClick={sendCommentary} style={{ backgroundColor: '#135A38' }} variant="contained" endIcon={<SendIcon />}>
                    Envoyer
                  </Button></center>
                </Box>
              </Modal>

              {/* Modal for setting */}
              {/* <Modal
                open={opens}
                onClose={handleCloses}
                aria-labelledby="modal-modal-title"
                aria-describedby="modal-modal-description"
              >
                <Box sx={styleS}>
                  <Grid
                    container
                    direction="column"
                    justifyContent="space-between"
                    alignItems="flex-start"
                  >
                    <h2>Paramettre de recherche </h2>


                    <Grid sx={{ mt: 4 }}>
                      <FormControl sx={{ m: 1, minWidth: 270 }} size="small">
                        <InputLabel id="demo-select-small-label">Profondeur</InputLabel>
                        <Select
                          labelId="demo-select-small-label"
                          id="demo-select-small"
                          value={level}
                          label="Niveau"
                          onChange={handleChangeLevel}
                        >
                          <MenuItem value={1}>Niveau1</MenuItem>
                          <MenuItem value={2}>Niveau2</MenuItem>
                          <MenuItem value={3}>Niveau3</MenuItem>
                          <MenuItem value={4}>Niveau4</MenuItem>

                        </Select>
                      </FormControl>
                    </Grid>

                 



                  </Grid>
                </Box>
              </Modal> */}
            </Grid>
            {loading ?


              <Grid
                container
                direction="row"
                justifyContent="center"
                alignItems="center"
                sx={{ mt: 35 }}
              >
                <Vortex
                  visible={true}
                  height="80"
                  width="200"
                  ariaLabel="vortex-loading"
                  wrapperStyle={{}}
                  wrapperClass="vortex-wrapper"
                  colors={['red', 'green', 'blue', 'yellow', 'orange', 'black']}
                />
              </Grid>
              :
              <Graph graph={graph} options={options} events={events} />}
          </Box>
     
        </Grid>
        {selectedNode || selectedEdge ?
          (
            openGrid ?
              (<Grid
                item
                xs={5}
                direction="column"
                justifyContent="flex-start"
                alignItems="flex-start"
              >

                <Grid
                  container
                  direction="row"
                  justifyContent="flex-end"
                  alignItems="flex-start"
                >
                  <IconButton
                    aria-label="close"
                    onClick={handleCloseGrid}
                    sx={{


                      //  right: 8,
                      //  top: 8,
                      color: "#B40000",
                    }}
                  >
                    <HighlightOffTwoToneIcon />
                  </IconButton> </Grid>


                <Box
                  sx={{

                    flexGrow: 1,
                    bgcolor: "background.paper",
                    // boxShadow: 7,
                    borderRadius: 1,
                    border: 1,
                    // borderColor: "black",
                  }}
                >
                  <TabContext value={value}>
                    <Box sx={{ borderBottom: 1, borderColor: "divider" }}>
                      <TabList
                        onChange={handleChange}
                        aria-label="lab API tabs example"
                      >
                        <Tab label="Informations" value="1" />
                        <Tab label="visualisation du voisinage" value="2" />
                        <Tab label="Explicabilité" value="3" />

                      </TabList>
                    </Box>
                    <TabPanel value="1">
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
                                    <b style={{ fontFamily: 'Montserrat' }}>{field.includes("Client SGCI") ? "Type client" : field.includes("NAER") ? "Domaine d'activité" : field.includes("PM") ? "Catégorie" : field} </b>
                                    <b style={{ fontSize: "1em", fontFamily: 'Montserrat' }}>
                                      {formatKeyResponse(key, node[selectedNode][key])}
                                    </b>
                                  </Grid>
                                );
                              })}
                          </Grid>
                        </>
                      ) : selectedEdge ? (
                        <>
                          <Grid
                            container
                            direction="column"
                            justifyContent="flex-start"
                            alignItems="baseline"
                          >
                            <Grid
                              container
                              direction="row"
                              justifyContent="space-between"
                              alignItems="flex-start"
                            >
                              <Grid>
                                Beneficiare :
                                <b sx={{ mt: 4, mb: 2 }}
                                  style={{ fontSize: "1em", color: "orange", fontFamily: 'Montserrat' }} >
                                  {`${selectedEdge["startNode_NAME"].toLowerCase()} `}
                                </b>
                              </Grid>
                              <Grid>
                                Recepteur : <b sx={{ ml: 4, mb: 2 }}
                                  style={{ fontSize: "1em", color: "orange", fontFamily: 'Montserrat' }} >
                                  {` ${selectedEdge["endNode_NAME"].toLowerCase()}`}
                                </b>
                              </Grid>


                            </Grid>


                            {Object.keys(selectedEdge)
                              .filter((key) => {
                                return key.startsWith("edge");
                              })
                              .map((key) => {
                                return (
                                  <Grid
                                    sx={{ mt: 4 }}
                                    container
                                    direction="row"
                                    justifyContent="space-between"
                                    alignItems="flex-start"
                                  >
                                    <b style={{ fontFamily: 'Montserrat', fontSize: "1em" }}>{infoLabel[key]} :</b>
                                    <b style={{ fontSize: "1em" }}>
                                      {formatKeyResponse(key, selectedEdge[key])}

                                      {/* {selectedEdge[key]} */}
                                    </b>
                                  </Grid>
                                );
                              })}
                          </Grid>
                        </>
                      ) : (
                        <Alert variant="filled" severity="warning">
                          Aucune informations disponible veuillez cliquer sur un nœuds ou une arêtes
                        </Alert>
                      )}
                    </TabPanel>
                    <TabPanel value="2">


                      {loadvisualization ?
                        <Grid container
                          direction="row"
                          justifyContent="center"
                          alignItems="center"   >
                          <ThreeCircles

                            visible={true}
                            height="50"
                            width="70"
                            color="#FF1E1E"
                            ariaLabel="three-circles-loading"
                            wrapperStyle={{}}
                            wrapperClass=""
                          />
                        </Grid>

                        :
                        graphevoisinage.length > 0 ? (
                          <Graph graph={graphVizualisation} options={optionsV} />
                        ) : (
                          <Alert variant="filled" severity="warning">
                            {errorVisualisation}
                          </Alert>
                        )}
                    </TabPanel>
                    <TabPanel value="3">
                      <Grid
                        container
                        direction="row"
                        justifyContent="flex-start"
                        alignItems="flex-start"
                      >
                        {explicability
                          ? Object.entries(explicability).map(([key, value]) => (
                            <Accordion defaultExpanded key={key}>
                              <AccordionSummary
                                expandIcon={<ExpandMoreIcon />}
                                aria-controls="panel3-content"
                                id="panel3-header"
                              >
                                <b
                                  style={{
                                    color: "#FA3500",
                                    fontFamily: "system-ui",
                                  }}
                                >
                                  {" "}
                                  {key}
                                </b>
                              </AccordionSummary>
                              <AccordionDetails style={{ fontFamily: "math" }}>
                                {value.message}
                              </AccordionDetails>
                            </Accordion>
                          ))
                          : "aucune info a affiché"}
                      </Grid>
                    </TabPanel>

                  </TabContext>
                </Box>
              </Grid>) : ""


          ) : ""}
      </Grid>
    </>
  );
}
