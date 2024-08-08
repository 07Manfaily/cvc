import React, { useState } from "react";
import EligibilityCheck from "./eligibilityCheck";
import Engagement from "./engagementTable";
import BeforeRequest from "./descriptifBeforeRequest";
import AfterRequest from "./descriptifAfterRequest";
import Stepper from "@mui/material/Stepper";
import Step from "@mui/material/Step";
import StepLabel from "@mui/material/StepLabel";
import Typography from "@mui/material/Typography";
import { Box, Grid } from "@mui/material";
import Button from "@mui/material/Button";
import { ColorRing } from "react-loader-spinner";

const steps = [
  "Contrôle d'Eligibilité",
  "Descriptifs avant la demande",
  "Descriptifs après la demande",
  "Détails des nouvelles autorisations"
];

export default function Credapp() {
  const [activeStep, setActiveStep] = useState(0);
  const [sendControl, setSendControl] = useState(null);
  const [sendDescriptif, setSendDescriptif] = useState(null);
  const [sendEngagement, setSendEngagement] = useState(null);

  const [loading, setLoading] = useState(false);

    //recuperation de la methode d'envoie des données(Controle d'eligibilité) depuis son fichier de creation 

  const getFunctionSendControlRef = (func) => {
    setSendControl(() => func);
  };

  const sendFunctionSendControl = async () => {
    if (sendControl) {
      setLoading(true);
      await sendControl();
      setLoading(false);
    }
  };
  //recuperation de la methode d'envoie des données(Descriptif après demande) depuis son fichier de creation 

  const getFunctionSendDescriptifRef = (func) => {
    setSendDescriptif(() => func);
  };
 const sendFunctionSendDescriptif = async () => {
    if (sendDescriptif) {
      setLoading(true);
      await sendDescriptif();
      setLoading(false);
    }
  };

  //recuperation de la methode d'envoie des données(engagement) depuis son fichier de creation 
  const getFunctionSendEngagementRef= (func) => {
    setSendEngagement(() => func);
  };
 const sendFunctionSendEngagement = async () => {
    if (sendDescriptif) {
      setLoading(true);
      await sendEngagement();
      setLoading(false);
    }
  };

  const handleNext = async () => {
    if (activeStep === 0) {
      await sendFunctionSendControl();
    }
     if(activeStep === 2){
      await  sendFunctionSendDescriptif();
    }
     if(activeStep === 3){
      await sendFunctionSendEngagement();
    }
    setActiveStep((prevActiveStep) => prevActiveStep + 1);
  };

  const handleBack = () => {
    setActiveStep((prevActiveStep) => prevActiveStep - 1);
  };

  const handleReset = () => {
    setActiveStep(0);
  };

  const getStepContent = (stepIndex) => {
    switch (stepIndex) {
      case 0:
        return <EligibilityCheck send={getFunctionSendControlRef} />;
      case 1:
        return <BeforeRequest />;
      case 2:
        return <AfterRequest sendValue={getFunctionSendDescriptifRef} />;
      case 3:
        return <Engagement sendEngagement={getFunctionSendEngagementRef}/>;
      default:
        return "Unknown stepIndex";
    }
  };

  return (
    <>
      {loading ? (
        <Box sx={{ display: "flex", justifyContent: "center", mt: 2 }}>
          <ColorRing
            visible={loading}
            height="80"
            width="80"
            ariaLabel="color-ring-loading"
            wrapperStyle={{}}
            wrapperClass="color-ring-wrapper"
            colors={['#e15b64', '#f47e60', '#f8b26a', '#abbd81', '#849b87']}
          />
        </Box>
      ) : (
        <>
          <Stepper activeStep={activeStep} sx={{ mt: 2, mb: 8 }}>
            {steps.map((label) => (
              <Step key={label}>
                <StepLabel>{label}</StepLabel>
              </Step>
            ))}
          </Stepper>
          {activeStep === steps.length ? (
            <>
              <Typography sx={{ mt: 2, mb: 1 }}>
                Toutes les étapes ont été complétées - vous avez terminé
              </Typography>
              <Box sx={{ display: "flex", flexDirection: "row", pt: 2 }}>
                <Box sx={{ flex: "1 1 auto" }} />
                <Button onClick={handleReset}>Réinitialiser</Button>
              </Box>
            </>
          ) : (
            <>
              <Grid sx={{ width: "97%", ml: 2 }}>{getStepContent(activeStep)}</Grid>
              <Box sx={{ display: "flex", flexDirection: "row", pt: 2, ml: 2, mr: 3 }}>
                <Button
                  variant="contained"
                  style={{ color: "white", backgroundColor: activeStep === 0 ? "" : "red" }}
                  disabled={activeStep === 0}
                  onClick={handleBack}
                  sx={{ mr: 1 }}
                >
                  Retour
                </Button>
                <Box sx={{ flex: "1 1 auto" }} />
                <Button
                  onClick={handleNext}
                  variant="contained"
                  style={{ color: "white", backgroundColor: "#38699f" }}
                >
                  {activeStep === steps.length - 1 ? "Terminer" : "Suivant"}
                </Button>
              </Box>
            </>
          )}
        </>
      )}
    </>
  );
}
