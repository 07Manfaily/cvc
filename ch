import React, { useState, useEffect } from "react";
import FormWizard from "react-form-wizard-component";
import "react-form-wizard-component/dist/style.css";
import EligibilityCheck from "./eligibilityCheck";
import Engagement from "./engagementTable";
import BeforeRequest from "./descriptifBeforeRequest";
import AfterRequest from "./descriptifAfterRequest";
import { handleSendEngagement } from "./engagementTable";
import { handleSendInsight } from "./descriptifAfterRequest";
import Stepper from "@mui/material/Stepper";
import Step from "@mui/material/Step";
import StepLabel from "@mui/material/StepLabel";
import Typography from "@mui/material/Typography";
import { Box, Grid } from "@mui/material";
import Button from "@mui/material/Button";

const steps = [
  "Contrôle d'Eligibilité",
  "Descriptifs avant la demande",
  "Descriptifs après la demande",
  "Détails des nouvelles autorisations"
];

export default function Credapp() {
  const [activeStep, setActiveStep] = React.useState(0);

  const handleNext = () => {
    setActiveStep((prevActiveStep) => prevActiveStep + 1);
    if(activeStep === 1){
      console.log("iiii");
    }
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
        return <EligibilityCheck />;
      case 1:
        return <BeforeRequest />;
      case 2:
        return <AfterRequest />;
      case 3:
        return <Engagement />;
      default:
        return "Unknown stepIndex";
    }
  };

  return (
    <>
      <Stepper activeStep={activeStep} sx={{ mt: 2, mb: 8}}>
        {steps.map((label, index) => {
          const stepProps = {};
          const labelProps = {};

          return (
            <Step  key={label} {...stepProps}>
              <StepLabel {...labelProps}>{label}</StepLabel>
            </Step>
          );
        })}
      </Stepper>
      {activeStep === steps.length ? (
        <React.Fragment>
          <Typography sx={{ mt: 2, mb: 1 }}>
            Toutes les étapes ont été complétées - vous avez terminé
          </Typography>
          <Box sx={{ display: "flex", flexDirection: "row", pt: 2 }}>
            <Box sx={{ flex: "1 1 auto" }} />
            <Button onClick={handleReset}>Réinitialiser</Button>
          </Box>
        </React.Fragment>
      ) : (
        <React.Fragment>
          <Grid sx={{ width: "97%", ml:2 }}>{getStepContent(activeStep)}</Grid>

          <Box sx={{ display: "flex", flexDirection: "row", pt: 2, ml:2, mr:3 }}>
            <Button variant="contained" style={{color:"white",backgroundColor: activeStep === 0 ? "" : "red"}} disabled={activeStep === 0} onClick={handleBack} sx={{ mr: 1 }}>
              Retour
            </Button>
            <Box sx={{ flex: "1 1 auto" }} />

            <Button onClick={handleNext} variant="contained" style={{color:"white",backgroundColor:"red"}}>
              {activeStep === steps.length - 1 ? "Terminer" : "Suivant"}
            </Button>
          </Box>
        </React.Fragment>
      )}
    </>
  );
}
