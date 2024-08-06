import React, { useState, useEffect, useRef } from "react";
import { useParams } from "react-router-dom";
import EligibilityCheck from "./eligibilityCheck";
import Engagement from "./engagementTable";
import BeforeRequest from "./descriptifBeforeRequest";
import AfterRequest from "./descriptifAfterRequest";
import { handleSendEngagement } from "./engagementTable";
import { ok } from "./engagementTable";
import { handleSendInsight,getData} from "./descriptifAfterRequest";
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
  let EligibilityCheckRef = useRef(null);
  const { Id } = useParams();
   useEffect(() => {
     if (activeStep === 3) {
       handleSendInsight(getData,Id);
       console.log("ddd",getData)
     }else if(activeStep === 1){
      EligibilityCheckRef.current.a();
     }
   }, [activeStep]);
  const handleNext = () => {
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
      <Stepper activeStep={activeStep} sx={{ mt: 2, mb: 8 }}>
        {steps.map((label, index) => {
          const stepProps = {};
          const labelProps = {};

          return (
            <Step key={label} {...stepProps}>
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
        </React.Fragment>
      )}
    </>
  );
}



import React, { useState, useEffect } from 'react';
import axios from "axios";
import { useParams } from "react-router-dom";
import getCookie from 'app/utils/getCookies';
import { Container, Button, Radio, TextField, Typography, Box, Grid, RadioGroup, FormControlLabel } from '@mui/material';
import { elegibilityData } from './questionControleElegibility';
import ThumbUpIcon from '@mui/icons-material/ThumbUp';
import ThumbDownIcon from '@mui/icons-material/ThumbDown';
import NavigateNextIcon from '@mui/icons-material/NavigateNext';
import NavigateBeforeIcon from '@mui/icons-material/NavigateBefore';

const dataElegibility = Object.entries(elegibilityData).map(([key, value]) => {
  return { key: value.key, title: value.title, desc: value.desc };
});

export default function EligibilityCheck({ radio, send }) {

  const [radioResult, setRadioResult] = useState()
  const [allRadio, setAllRadio] = useState()
  const [currentQuestion, setCurrentQuestion] = useState(0);
  const [answers, setAnswers] = useState(Array(dataElegibility.length).fill({ radio: '', comment: '' }));
  const { Id } = useParams();

  const handleSendControl = async () => {
    try {
      const dataToSend = {
        data: dataElegibility.map((item, index) => ({
          label: item.key,
          value: answers[index].radio,
          comment: answers[index].comment
        })),
        Id
      };
      const valuesOnly = dataToSend.data.map(item => item.value);
      const allValuesAreOne = valuesOnly.every(value => value == 1);
      setAllRadio(allValuesAreOne)

      const response = await axios
        .post("/api/pt",
          {
            "data": dataToSend,
            "number_client": Id
          }, {
          headers: {
            'Content-Type': 'application/json',
            'X-CSRF-TOKEN': getCookie("csrf_refresh_token")
          }
        })
    } catch (error) {
      console.log("Erreur lors du traitement:", error);
    }

  };

  const handleGetControlEligibite = async () => {
    try {
      const response = await axios
        .post(
          "/api/pa",
          { number_client: Id },
          {
            headers: {
              "Content-Type": "application/json",
              "X-CSRF-TOKEN": getCookie("csrf_refresh_token"),
            },
          },
        )
      const data = response.data.data
      const initialAnswers = dataElegibility.map((item, index) => {
        const fetchedItem = Object.entries(data).find(([key, value]) => key === item.key);
        const validity = fetchedItem ? fetchedItem[1].condition : null;
        setRadioResult(validity)

        return {
          radio: validity ? (validity === true ? '1' : '0') : '',
        };
      });
      setAnswers(initialAnswers);

    } catch (error) {
      console.log("Error lors du traitement de control eligibilité:", error);
    }

  };
  const handleNext = () => {
    setCurrentQuestion((prev) => Math.min(prev + 1, dataElegibility.length - 1));
  };

  const handleBack = () => {
    setCurrentQuestion((prev) => Math.max(prev - 1, 0));
  };

  const handleAnswerChange = (index, field, value) => {
    const newAnswers = [...answers];
    newAnswers[index] = { ...newAnswers[index], [field]: value };
    setAnswers(newAnswers);
  };

  const handleQuestionClick = (index) => {
    if (answers[index].radio) {
      setCurrentQuestion(index);
      console.log("radio", answers[index].radio);
    }
  };

  const isQuestionValid = (index) => {
    return answers[index].radio;
  };

  useEffect(() => {
    if (Id) {
      handleGetControlEligibite()
    }
  }, [Id]);

  return (
    <Grid container direction="column" justifyContent="space-between" alignItems="flex-start" 
    sx={{ border: '1px solid #9B9B9B', background:  `linear-gradient(#EEEEEE, #EEEEEE)` }}>
      <Grid item m={4} display="flex" justifyContent="center">
        <Grid container spacing={2}>
          {answers.map((_, index) => (
            <Grid item key={index}>
              <Button
                style={{ backgroundColor: isQuestionValid(index) ? (answers[index].radio == 1 ? "#187857" : "#BB4141") : "#F2F2F2" }} variant="contained"
                onClick={() => handleQuestionClick(index)}
                disabled={!isQuestionValid(index)}
              >
                {index + 1}
              </Button>
            </Grid>
          ))}
        </Grid>
      </Grid>
      <Grid item m={2}>
        <Grid container direction="column" justifyContent="space-between" alignItems="flex-start">
          <Grid item xs={10}>
            <Grid container direction="column" justifyContent="space-between" alignItems="flex-start">
              <Grid item>
                <b style={{ fontSize: "17px", fontFamily: "system-ui" }}>{dataElegibility[currentQuestion].desc}</b>
              </Grid>
              <Grid item>
                <TextField
                  style={{ width: 500 }}
                  multiline
                  value={answers[currentQuestion].comment}
                  onChange={(e) => handleAnswerChange(currentQuestion, 'comment', e.target.value)}
                  placeholder="Commentaire........"
                  fullWidth
                  margin="normal"
                />
              </Grid>
            </Grid>
          </Grid>
          <Grid item xs={2}>
            <RadioGroup
              value={answers[currentQuestion].radio}
              onChange={(e) => handleAnswerChange(currentQuestion, 'radio', e.target.value)}
            >
              <FormControlLabel value="1" control={<Radio />} label={<ThumbUpIcon style={{ color: "green" }} />} />
              <FormControlLabel value="0" control={<Radio />} label={<ThumbDownIcon style={{ color: "red" }} />} />
            </RadioGroup>
          </Grid>
        </Grid>
      </Grid>
      <Grid item m={2}>
        <Button variant="contained" onClick={handleBack} disabled={currentQuestion === 0}>
          <NavigateBeforeIcon />
        </Button>
        <Button variant="contained" onClick={handleNext} disabled={!answers[currentQuestion].radio} sx={{ ml: 2 }}>
          <NavigateNextIcon />
        </Button>
      </Grid>
    </Grid>
  );
}
