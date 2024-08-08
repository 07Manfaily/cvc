
import React, { useState, useEffect} from 'react';
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

export default function EligibilityCheck({send,resultat})  {

  const [radioResult, setRadioResult] = useState()
  const [allRadio, setAllRadio] = useState()
  const [currentQuestion, setCurrentQuestion] = useState(0);
  const [answers, setAnswers] = useState(Array(dataElegibility.length).fill({ radio: '', comment: '' }));
  const { Id } = useParams();

  const result = 
    dataElegibility.map((item, index) => ({
      label: item.key,
      value: answers[index].radio,
      comment: answers[index].comment
    })).map(item => item.value).every(value => value == 1)
  
  // const valuesOnly = result.map(item => item.value);
  // const allValuesAreOne = valuesOnly.every(value => value == 1);

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
      const response = await axios
        .post("/api/panel/eligibility/set",
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
    }}
    useEffect(() => {
      if(send){
        send(handleSendControl)
      }else if(resultat){
        resultat(result)
      }
    }, [send,resultat]);



  const handleGetControlEligibite = async () => {
    try {
      const response = await axios
        .post(
          "/api/panel/eligibility",
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

        <Button variant="contained" onClick={()=>{console.log("all", handleSendControl(), "r", allRadio)}}  sx={{ ml: 2 }}>
      testx
        </Button>
      </Grid>
    </Grid>
  );
 }




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
  const [checkResult, setCheckResult] = useState(null);

  const [sendDescriptif, setSendDescriptif] = useState(null);
  const [sendEngagement, setSendEngagement] = useState(null);

  const [loading, setLoading] = useState(false);

    //recuperation de la methode d'envoie des données(Controle d'eligibilité) depuis son fichier de creation 

  const getFunctionSendControlRef = (func) => {
    setSendControl(() => func);
  };

  
  const getCkeckRef = (func) => {
    setCheckResult(() => func);
  };


  const show = async () => {
    if (checkResult) {
   
checkResult()
    }
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
    if (sendEngagement) {
      setLoading(true);
      await sendEngagement();
      setLoading(false);
    }
  };

  const handleNext = async () => {
    if (activeStep === 0) {
      await sendFunctionSendControl();
    }
     else if(activeStep === 2){
      await  sendFunctionSendDescriptif();
    }
     else if(activeStep === 3){
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
        return <EligibilityCheck send={getFunctionSendControlRef} resultat={getCkeckRef} />;
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

                <Button variant="contained" onClick={()=>{console.log("fffr",show()}}  sx={{ ml: 2 }}>
      tes
        </Button>
              </Box>
            </>
          )}
        </>
      )}
    </>
  );
}
