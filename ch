import React, { useState, useEffect } from "react";
import axios from "axios";
import { Helmet } from "react-helmet-async";
import { Grid, Box, Button, Card, Container, Typography } from "@mui/material";
import Graph from "react-graph-vis";
import Modal from "@mui/material/Modal";
import Drawer from '@mui/material/Drawer';
import TextField from '@mui/material/TextField';
import Checkbox from '@mui/material/Checkbox';
import Slider from '@mui/material/Slider';
import MenuItem from '@mui/material/MenuItem';
import FormControl from '@mui/material/FormControl';
import Select from '@mui/material/Select';
import InputLabel from '@mui/material/InputLabel';
import SendIcon from '@mui/icons-material/Send';
import { getCookie } from '../utils/getCookies'
import { Vortex } from 'react-loader-spinner';



export default function RiskChaine() {
    const style = {
        position: "absolute",
        top: "50%",
        left: "80%",
        transform: "translate(-50%, -50%)",
        width: 400,
        height: 750,
        bgcolor: "background.paper",
        border: "2px solid #000",
        boxShadow: 24,
        p: 4,
    };

    const [open, setOpen] = React.useState(false);
    const handleOpen = () => setOpen(true);
    const handleClose = () => setOpen(false);
    const [clientCode, setClientCode] = React.useState("")
    const [weight, setWeight] = React.useState(1)
    const [direction, setDirection] = React.useState(1);
    const [level, setLevel] = React.useState(2);
    const [riskCategory, setRiskCategory] = React.useState([]);
    const [slide, setSlide] = React.useState(1);
    const [graphe, setGraphe] = React.useState([])
    const [node, setNode] = React.useState(new Set())
    const [loading, setLoading] = useState(false);



    const handleChangeCodeClient = (event) => {
        setClientCode(event.target.value);
    };
    const handleChangeDirection = (event) => {
        setDirection(event.target.value);
    };

    const handleChangeLevel = (event) => {
        setLevel(event.target.value);
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

    const fetchGraph = async () => {
        handleClose()
        try {
            const response = await axios.post("/api/graph",
                {
                    "client_code_id": clientCode,
                    "direction": direction,
                    "ftop_value": weight ? 0 : 1,
                    "ftransaction_weight": weight ? 1 : 0,
                    "fvalue": slide,
                    "level": level,
                    "risk_category": riskCategory
                },
                {
                    headers: {
                        'Content-Type': 'application/json',
                        'X-CSRF-TOKEN': getCookie("csrf_refresh_token")
                    }
                },

            );
           // setGraphe(response.data.data)
            if (response.status === 200) {
                setGraphe(response.data.data)
                setLoading(false)
              //  setClientCode("")
                setWeight(1)
                setDirection(1)
                setLevel(2)
                setRiskCategory([])
                setSlide(1)

            }
            const noeuds = new Set(response.data.data.map((rel) => {
                return [
                    rel.emitter_code_id,
                    rel.receiver_code_id

                ]
            }).reduce((a, b) => a.concat(b), []

            ))
            setNode(noeuds);
            console.log("les nodes", noeuds)
        }
        catch (error) {
            console.log("Erreur lors du traitement:", error);
        }
    }
    const nodes = [...node].map((i) => {
        return {
            id: i,
            label: i,
            shape: i === parseInt(clientCode, 10) ? "diamond" : "ellipse",

            
    
        }
    })
 
    const edges = graphe.map((i) => {
        return {
            from: i.emitter_code_id,
            to: i.receiver_code_id,
            color: "#009E3A"
        }
    })

    const graph = {
        nodes,
        edges
    };
    const events = {
        select: function(event) {
          var { nodes, edges } = event;
        }
      };

    const 
    options = {
        nodes: {
       
          font: {
            size: 10,
            face: "Tahoma",
          },
        },
        physics: {
          forceAtlas2Based: {
            gravitationalConstant: -80,
            centralGravity: 0.005,
            springLength: 50,
            springConstant: 0.15,
          },
          maxVelocity: 146,
          solver: "forceAtlas2Based",
          timestep: 0.35,
          stabilization: { iterations: 300 },
        },
        interaction: { hover: true },
        edges: {
          width: 1,
          font: { size: 10 },
          smooth: {
            type: "continuous",
          },
        },

      };
  

    return (
        <>
            <Modal
                open={open}
                onClose={handleClose}
                aria-labelledby="modal-modal-title"
                aria-describedby="modal-modal-description"
            >
                <Box sx={style}>
                    <Grid
                        container
                        direction="column"
                        justifyContent="space-between"
                        alignItems="flex-start"
                        sx={{ p: 2 }} // Ajoutez un padding au contenu du Drawer
                    >
                        <h2>Paramettre de recherche </h2>
                        <Grid sx={{ mt: 4 }}>
                            {/* <p>Choisissez parmis les options</p> */}

                            <TextField sx={{ minWidth: 270 }}
                                fullWidth label="Code client"
                                id="fullWidth"
                                size="small"
                                value={clientCode}
                                onChange={handleChangeCodeClient}
                            />
                        </Grid>
                        <Grid sx={{ mt: 4 }}>
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
                        <Grid sx={{ mt: 4 }} >
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
                        </Grid>
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
                        <Grid sx={{ mt: 4 }}>
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
                        </Grid>
                        <Grid sx={{ mt: 4, width: 320 }} >
                            <Slider style={{ color: "#0D7C00", }} defaultValue={1} marks
                                min={1}
                                onChange={handleChangeSlide}
                                value={slide}
                                max={100} aria-label="Default" valueLabelDisplay="auto" />

                        </Grid>
                        <Button sx={{ mt: 4 }} onClick={fetchGraph} style={{ backgroundColor: '#135A38', width: 300 }} variant="contained" endIcon={<SendIcon />}>
                            Lancer
                        </Button>



                    </Grid>
                </Box>
            </Modal>
            <Helmet>
                <title> Chaine de valeur </title>
            </Helmet>
            <Button variant="contained" style={{ backgroundColor: "red", position: "fixed", top: 900, right: 0, zIndex: 100 }} onClick={handleOpen}>
                {open ? "Fermer" : "Filter"}
            </Button>
            {/* <Button style={{ position: "fixed", top: 900, right: 0, zIndex: 100 }} onClick={toggleDrawer(true)}>Filter</Button> */}



            <Grid container spacing={2}>
                <Grid item xs={12} md={12} lg={12}>
                    <Box
                        sx={{
                            // bgcolor: "background.paper",
                            bgcolor: "#ddd",
                            boxShadow: 7,
                            borderRadius: 1,
                            border: 1,
                            borderColor: "#e7e0e0",
                            height:"100vh"
                        }}
                        id="network"
                    >
                        {loading ? 
                    
                    <Grid
                    container
                    direction="row"
                    justifyContent="center"
                    alignItems="center"
            
                  >
                    <Vortex
                      visible={true}
                      height="80"
                      width="200"
                      ariaLabel="vortex-loading"
                      wrapperStyle={{}}
                      wrapperClass="vortex-wrapper"
                      colors={['red', 'green', 'blue', 'yellow', 'orange', 'black']}
                    /></Grid> :   <Graph graph={graph} options={options} events={events} />
                    }
                        

                      

                    </Box>
                </Grid>

            </Grid>
        </>
    );
}










const handleOpen = () => {
  setModalLoading(true); // Mettre l'état de chargement spécifique au modal à true avant la requête
  setOpen(true); // Ouvrir le modal

  // Appeler fetchGraph
  fetchGraph()
    .then(() => {
      setModalLoading(false); // Mettre l'état de chargement spécifique au modal à false une fois la requête terminée
      handleClose(); // Fermer le modal une fois que les données sont chargées avec succès
    })
    .catch((error) => {
      setModalLoading(false); // Mettre l'état de chargement spécifique au modal à false en cas d'erreur
      console.error("Erreur lors du chargement des données:", error);
    });
};


// Ajoutez un nouvel état pour suivre l'état de chargement
const [loading, setLoading] = useState(false);

// Modifiez fetchGraph pour qu'il mette à jour l'état de chargement
const fetchGraph = async () => {
  try {
    setLoading(true); // Mettre l'état de chargement à true avant la requête

    const response = await axios.get(
      `/api/risk/get-neighborhood?FINAL_CLUSTERS=${clusterId.clusterId}&depth=${level}`
    );

    // Traitez la réponse

  } catch (error) {
    // Gérez les erreurs
  } finally {
    setLoading(false); // Mettre l'état de chargement à false une fois la requête terminée
  }
};

// Utilisez un useEffect pour appeler fetchGraph lorsque le composant est monté ou lorsque le niveau change
useEffect(() => {
  fetchGraph();
}, [level]); // Assurez-vous de passer [level] comme dépendance pour que fetchGraph soit appelé à chaque fois que le niveau change

// Affichez le loader tant que la requête est en cours
{loading && <LoaderComponent />}

// Affichez le graphique une fois que la requête est terminée
{!loading && <Graph graph={graph} options={options} events={events} />}




import React, { useState, useEffect } from "react";
import axios from "axios";
import { useParams } from "react-router-dom";
import { Helmet } from "react-helmet-async";
import { Grid, Box, Button, Typography } from "@mui/material";
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
import Paper from "@mui/material/Paper";
import Fab from "@mui/material/Fab";
import SpeakerNotesIcon from "@mui/icons-material/SpeakerNotes";
import Accordion from "@mui/material/Accordion";
import ThumbUpAltIcon from '@mui/icons-material/ThumbUpAlt';
import ThumbDownIcon from '@mui/icons-material/ThumbDown';
import AccordionSummary from "@mui/material/AccordionSummary";
import AccordionDetails from "@mui/material/AccordionDetails";
import ExpandMoreIcon from "@mui/icons-material/ExpandMore";
import Radio from '@mui/material/Radio';
import SendIcon from '@mui/icons-material/Send';
import Alert from '@mui/material/Alert';
import { formatKeyResponse } from '../utils/formatResponse';
import SettingsIcon from '@mui/icons-material/Settings';
import TextField from '@mui/material/TextField';
import Checkbox from '@mui/material/Checkbox';
import MenuItem from '@mui/material/MenuItem';
import FormControl from '@mui/material/FormControl';
import Select from '@mui/material/Select';
import InputLabel from '@mui/material/InputLabel';
import SearchIcon from '@mui/icons-material/Search';

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

  const styleS = {
    position: "absolute",
    top: "50%",
    left: "50%",
    transform: "translate(-50%, -50%)",
    width: 400,
    height: 320,
    bgcolor: "background.paper",
    border: "2px solid #000",
    boxShadow: 24,
    p: 4,
  };

  const [opens, setOpens] = React.useState(false);
  const handleOpens = () => setOpens(true);
  const handleCloses = () => setOpens(false);
  const [value, setValue] = React.useState("1");

  const handleChange = (event, newValue) => {
    setValue(newValue);
  };
  const handleChangeLevel = (event) => {
    setLevel(event.target.value);
  };
  const [level, setLevel] = React.useState(2);

  const [open, setOpen] = React.useState(false);
  const handleOpen = () => setOpen(true);
  const handleClose = () => setOpen(false);
  const [selectedNode, setSelectedNode] = useState(null);
  const [selectedEdge, setSelectedEdge] = useState(null);
  const [infoLabel, setInfoLabel] = useState([]);
  const [graphe, setGraphe] = useState([]);
  const [node, setNode] = useState([]);
  const [graphevoisinage, setGrapheVoisinage] = useState([]);
  const [error, setError] = useState("");
  const [explicability, setExplicability] = useState([]);
  const [response1, setResponse1] = React.useState(0);
  const [response2, setResponse2] = React.useState(0);
  const [response3, setResponse3] = React.useState(0);
  const [response4, setResponse4] = React.useState(0);
  const [response5, setResponse5] = React.useState(0);
  const [message, setMessage] = React.useState("");
  const [vrai, setVrai] = React.useState(false)

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
      const response = await axios.post("/api/risk/set-analyse-comment",
        {
          quiz1: response1,
          quiz2: response2,
          quiz3: response3,
          quiz4: response4,
          quiz5: response5
        },
        {
          headers: {
            'Content-Type': 'application/json',
          }
        }
      );
      if (response.status === 200) {
        setMessage("Commentaire envoyé avec succès")
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
      setError("Oups !!!! erreur liée au serveur");
    }
  }

  const clusterId = useParams();

  // useEffect(() => {
    const fetchGraph = async () => {
      try {
        const response = await axios.get(
          `/api/risk/get-neighborhood?FINAL_CLUSTERS=${clusterId.clusterId}&depth=${level}`
        );
        console.log("Réponse gaph:", response);


        if (response.status === 201) {
          setError("Désolé aucun client trouvé")
        }

        if (response.status === 200) {
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

          setGraphe(dataset);
          setNode(getNode);
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

  //   if (graphe) {
  //     fetchGraph();
  //   }
  // }, []);

  useEffect(() => {
    const fetchGraphVizualisation = async () => {
      try {
        const response = await axios.get(
          `/api/risk/get-grouping-graph?FINAL_CLUSTERS=${selectedNode}`
        );
        console.log("Réponse du graphe de vouisinnage:", response);

        if (response.status === 200) {
          const data = response.data.data;
          setGrapheVoisinage([])
          setGrapheVoisinage(data);
          console.log("voisinage", data)
        }
        if (response.status === 201) {
          setVrai(true)
        }
      } catch (error) {
        console.log("Erreur lors du traitement:", error);
        setError("Oups !!!! erreur liée au serveur");
        console.log(
          error.response?.data ||
          "Oups!!!! une erreur s'est produite impossible de recupére le voisignage"
        );
      }
    };

    if (selectedNode) {
      fetchGraphVizualisation();
    }
  }, [selectedNode]);
  useEffect(() => {
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

    if (explicability) {
      fetchExplainability();
    }
  }, []);
  // Création d'un objet pour regrouper les entreprises par IBAN ou CLUSTERING_NAME
  const groupedData = {};
  graphevoisinage.forEach((item) => {
    const key = item.CLUSTERING_NAME || item.CLUSTERING_IBAN;
    if (!groupedData[key]) {
      groupedData[key] = [];
    }
    groupedData[key].push(item);
  });

  // Création des noeuds pour chaque entreprise unique
  const nodesVoisinage = graphevoisinage.map((e) => ({
    id: e.IBAN,
    label: e.Name,
    shape: "dot",
    color: "#79B6DE",
  }));

  // Création des aretes entre les noeuds ayant le mme IBAN ou CLUSTERING_NAME
  const edgesVoisinage = [];
  Object.values(groupedData).forEach((group) => {
    if (group.length > 1) {
      for (let i = 0; i < group.length - 1; i += 1) {
        for (let j = i + 1; j < group.length; j += 1) {
          edgesVoisinage.push({ from: group[i].IBAN, to: group[j].IBAN });
        }
      }
    }
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
    shape: item.id === parseInt(clusterId.clusterId, 10) ? "diamond" : "dot",
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

  const edges = graphe.map((item) => ({
    from: item.startNode_ID,
    to: item.endNode_ID,
    // length:item.edge_TOTAL_FLUX/2500000,
    //  value: item.edge_TOTAL_FLUX,
    value:
      item.startNode_ID === parseInt(clusterId.clusterId, 10)
        ? item.edge_RATIO_FLUX_EMIS
        : item.edge_RATIO_FLUX_RECU,
    color:
      item.startNode_ID === parseInt(clusterId.clusterId, 10)
        ? "#009E3A"
        : "#0081B9",
    ...item,
    //  value:item.edge_RATIO_FLUX_RECU
  }));
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
            <Grid
              sx={{
                mt: 4,
                pr: 2,
              }}
              container
              direction="row-reverse"
              justifyContent="flex-start"
              alignItems="flex-start"
            >
              {" "}
              <Fab onClick={handleOpen} variant="extended">
                <SpeakerNotesIcon style={{ color: "green" }} />
              </Fab>
              <Fab sx={{

                mr: 2
              }} onClick={handleOpens} variant="extended">
                <SettingsIcon style={{ color: "red" }} />
              </Fab>


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
                      Veillez repondre a cette enquete !!
                    </Typography>
                    {message ? (
                      <Alert variant="outlined" severity="success">
                        <b><h3> {message}</h3></b>
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
                      }}>Les données affichées sont t'elle éronnées ou s'affichent correctement ?</b>
                      <Grid>  <Radio
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
                    <Grid sx={{ mt: 2 }} container
                      direction="row"
                      justifyContent="space-between" alignItems="flex-start">


                      <b style={{
                        fontFamily: "math"
                      }}>Y as t'il une information complementaire dont vous auriez eu besion non présente?</b>
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
                    <Grid sx={{ mt: 2 }} container
                      direction="row"
                      justifyContent="space-between" alignItems="flex-start">


                      <b style={{
                        fontFamily: "math"
                      }}>Les zones d'investigation recommandés par la chaine de valeur etaient t'elle pertinente ?</b>
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
                      }}>Le client est t'il catégorisé en rouge ou orange alors qu'il y as des suspicions d'anomalie a creuser ?</b>
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
                      }}>Le client est t'il catégorisé en vert alors qu'il y as des suspicions d'anomalie a creuser ?</b>
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
              <Modal
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
                    sx={{ p: 2 }} // Ajoutez un padding au contenu du Drawer
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


                    <Button sx={{ mt: 4 }} onClick={fetchGraph} style={{ backgroundColor: '#C45900', width: 300 }} variant="contained" endIcon={<SearchIcon/>}>
                      Rechercher
                    </Button>



                  </Grid>
                </Box>
              </Modal>
            </Grid>
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
                <div>

                  {graphevoisinage.length > 0 ? (
                    <Graph graph={graphVizualisation} options={optionsV} />
                  ) : (
                    ""
                  )}
                </div>
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
        </Grid>
      </Grid>
    </>
  );
}
