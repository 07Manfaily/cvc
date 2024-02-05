import React, { useState } from 'react';

import { Helmet } from 'react-helmet-async';
import { faker } from '@faker-js/faker';
// @mui
import { useTheme } from '@mui/material/styles';
import { Grid, Box, Button, Card, Container, Typography } from '@mui/material';
import Graph from 'react-graph-vis';
import Modal from '@mui/material/Modal';
import CardHeader from '@mui/material/CardHeader';
import CardContent from '@mui/material/CardContent';
import CardActions from '@mui/material/CardActions';

// components
import Iconify from '../components/iconify';
import Data from './data.json';

// sections
import { AppTasks, AppOrderTimeline, AppTrafficBySite } from '../sections/@dashboard/app';

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
        to: item.CLI_S, value: item.MontantXOF }));

    const graph = {
        nodes,
        edges,
    };

    const options = {
        layout: {
            hierarchical: false
          },
        nodes: {
            shape: 'dot',
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
            borderWidth: 7,
            color: {
                border: 'gray',
                background: 'red',
                
            },
           
        },
        edges: {
            color: { color: "blue" },
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
        height: '500px',
        width: '1200px',
    };

    const handleNodeClick = (event) => {
        const { nodes } = event;
        if (nodes.length > 0) {
            setSelectedNode(nodes[0]);
            handleOpenModal();
        }
    };

    const events = {
        click: handleNodeClick,
    };

    return (
        <>
            <Helmet>
                <title> Chaine de valeur </title>
            </Helmet>

            <Container maxWidth="xl">
            <Grid container spacing={3}>
                <Grid item xs={12} md={6} lg={8}>
                <Card>
                        <div id="network">
                            <Graph graph={graph} options={options} events={events} />
                        </div>
                        <Modal open={openModal} onClose={handleCloseModal}>
                            <Box
                                sx={{
                                    position: 'absolute',
                                    top: '50%',
                                    left: '50%',
                                    transform: 'translate(-50%, -50%)',
                                    width: 400,
                                    bgcolor: 'background.paper',
                                    boxShadow: 24,
                                    p: 4,
                                }}
                            >
                                <Typography variant="h6" component="h2">
                                    Noeud sélectionné: {selectedNode}
                                </Typography>
                                <Button onClick={handleCloseModal}>Fermer</Button>
                            </Box>
                        </Modal>
                    </Card>
                </Grid >
                <Grid item xs={12} md={6} lg={4}>
                    
                    <Card sx={{ backgroundColor: '#CACFC5' }}> 
                    <CardHeader title={'Légende'}  />      
                    <CardContent>
                    <figure>
                    <figcaption>Clients en S2</figcaption>
                  </figure>
                    </CardContent>
                     </Card>
                      
                </Grid>

                </Grid>
        </Container>
        </>
    );
}
