import React, { useState } from 'react';

import { Helmet } from 'react-helmet-async';
import { faker } from '@faker-js/faker';
// @mui
import { useTheme } from '@mui/material/styles';
import { Grid, Box, Button, Card, Container, Typography } from '@mui/material';
import Graph from 'react-graph-vis';
import Modal from '@mui/material/Modal';

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
        emet: true,
        title: `MontantXOF: ${item.MontantXOF}`,
    }));

    const edges = jsondata.map((item) => ({ from: item.CLI_Emet, to: item.CLI_S, value: item.MontantXOF }));

    const graph = {
        nodes,
        edges,
    };

    const options = {
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
                border: 'yellow',
                background: 'grey',
            },
        },
        edges: {
            arrows: {
                to: {
                    enabled: true,
                    scaleFactor: 1,
                    type: 'arrow',
                    color: 'green',
                },
                from: {
                    scaleFactor: 1,
                    type: 'arrow',
                    color: 'red',
                },
            },
            shadow: false,
        },
        interaction: {
            hover: true,
        },
        physics: {
            stabilization: {
                enabled: true,
                iterations: 1000,
                fit: true,
            },
        },
        configure: {
            enabled: false,
        },
        height: '600px',
        width: '500px',
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
                        <AppOrderTimeline
                            title="Legende"
                            list={[...Array(5)].map((_, index) => ({
                                id: faker.datatype.uuid(),
                                title: [
                                    '1983, orders, $4220',
                                    '12 Invoices have been paid',
                                    'Order #37745 from September',
                                    'New order placed #XF-2356',
                                    'New order placed #XF-2346',
                                ][index],
                                type: `order${index + 1}`,
                                time: faker.date.past(),
                            }))}
                        />
                </Grid>

                </Grid>
        </Container>
        </>
    );
}
