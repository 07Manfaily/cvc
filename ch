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
  const { id } = useParams();

  const handleSendControl = async () => {
    try {
      const dataToSend = {
        data: dataElegibility.map((item, index) => ({
          label: item.key,
          value: answers[index].radio,
          comment: answers[index].comment
        })),
        id
      };
      const valuesOnly = dataToSend.data.map(item => item.value);
      const allValuesAreOne = valuesOnly.every(value => value == 1);
      setAllRadio(allValuesAreOne)

      const response = await axios
        .post("/api/panel/eligibility/set",
          {
            "data": dataToSend,
            "number_client": id
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
          "/api/panel/eligibility",
          { number_client: id },
          {
            headers: {
              "Content-Type": "application/json",
              "X-CSRF-TOKEN": getCookie("csrf_refresh_token"),
            },
          },
        )
      const data = response.data.data
      // methode pour remplir les radios de manière automatique tout en verifians par clés
      const initialAnswers = dataElegibility.map((item, index) => {
        const fetchedItem = Object.entries(data).find(([key, value]) => key === item.key);
        const validity = fetchedItem ? fetchedItem[1].condition : null;
        setRadioResult(validity)

        return {
          radio: validity ? (validity === true ? '1' : '0') : '',
          // comment: fetchedItem ? fetchedItem.comment : ''
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
  const checkAllQuestionsValid = (answers) => {
    const allValid = answers.every(answer => answer.radio === '1');
    console.log("allvalid", allValid);
  };


  const handleAnswerChange = (index, field, value) => {
    const newAnswers = [...answers];
    newAnswers[index] = { ...newAnswers[index], [field]: value };
    setAnswers(newAnswers);
  };

  const handleQuestionClick = (index) => {
    if (answers[index].radio) {
      setCurrentQuestion(index);
    }
  };

  const isQuestionValid = (index) => {
    return answers[index].radio;
  };

  useEffect(() => {
    if (id) {
      handleGetControlEligibite()
    }
  }, [id])
  return (

    <Grid container direction="column"  justifyContent="space-between" alignItems="flex-start" sx={{border: '1px solid #9B9B9B', backgroundColor: "none" }}  >
      <Grid item m={4} display="flex" justifyContent="center">
        <Grid container spacing={2}>
          {answers.map((_, index) => (
            <Grid item key={index}>
              <Button
                variant="contained"
                onClick={() => handleQuestionClick(index)}
                disabled={!isQuestionValid(index)}
              >
                {index + 1}
              </Button>
            </Grid>
          ))}
        </Grid>
        {/* <Button
          variant="contained"
          onClick={() => handleSendControl()}
        >
          send
        </Button> */}
      </Grid>
      <Grid item m={2}>
        <Grid container  direction="row" justifyContent="space-between"  alignItems="flex-start">
          <Grid item xs={10}>
            <Grid direction="column" justifyContent="space-between" alignItems="flex-start">
              {/* <Grid item>
                <Typography variant="h6" gutterBottom>{dataElegibility[currentQuestion].title}</Typography>
              </Grid> */}
              <Grid item>
                <b style={{fontSize:"17px", fontFamily:"Math"}}>{dataElegibility[currentQuestion].desc}</b>
              </Grid>
              <Grid item>
                <TextField
                  multiline
                  value={answers[currentQuestion].comment}
                  onChange={(e) => handleAnswerChange(currentQuestion, 'comment', e.target.value)}
                  placeholder="Ajouter un commentaire"
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
  
     
      <Grid item m={4}>
            <Button variant="contained" onClick={handleBack} disabled={currentQuestion === 0}>
              <NavigateBeforeIcon />
            </Button>
            {/* currentQuestion === dataElegibility.length - 1 &&  */}
            <Button variant="contained" onClick={handleNext} disabled={!answers[currentQuestion].radio} sx={{ ml: 2 }}>
              <NavigateNextIcon />
            </Button>
          </Grid>
    </Grid>
  );
}


export const elegibilityData = [
  {
    "key": "financial_compensation", 
    "desc": "Contrepartie en S1", 
    "title": "Contrepartie en S1"
  },
    {
      "key": "kyc_validity", 
      "desc": "KYC valide et fiche de contrôle conformité dûment remplie", 
      "title": "Validité KYC"
    },
    {
      "key": "pcru", 
      "desc": "PCRU local", 
      "title": "PCRU local"
    },
   
    {
      "key": "local_cro", 
      "desc": "Dans la LAD du CRO local", 
      "title": "LAD du CRO local"
    },
    {
      "key": "last_review", 
      "desc": "La précédente revue était une revue complète", 
      "title": "La précédente revue était une revue complète"
    },
    {
      "key": "no_new_review_required", 
      "desc": "A la précédente revue, absence de demande expresse par RISQ de faire une nouvelle revue complète", 
      "title": "A la précédente revue, absence de demande expresse par RISQ de faire une nouvelle revue complète"
    },
    {
      "key":  "financial_compensation_activity_nature", 
      "desc":  "Nature d’activité de la contrepartie inchangée", 
      "title":  "Nature d’activité de la contrepartie inchangée"
    },
    {
      "key":  "sales_evolution", 
      "desc":  "Evolution du CA sur 1 an comprise entre -10% et +20%", 
      "title": "Evolution du CA sur 1 an comprise entre -10% et +20%"
    },
    {
      "key":  "activity_sector",
      "desc": "Pas d’évolution législative majeure sur le secteur d’activité",
      "title": "Pas d’évolution législative majeure sur le secteur d’activité"
    },
    {
      "key":  "shareholding_change",
      "desc": "Aucun changement d’actionnariat engendrant une modification du contrôle de l’entreprise",
      "title": "Aucun changement d’actionnariat engendrant une modification du contrôle de l’entreprise"
    },
    {
      "key":  "no_occurred_bad_event",
      "desc": "Absence d’événement significatif défavorable depuis la dernière revue",
      "title": "Absence d’événement significatif défavorable depuis la dernière revue"
    },
    {
      "key":  "financial_statement_availability",
      "desc": "EF définitifs déposés à l’administration fiscale avec cachet d’un cabinet d’audit et/ou visa CAC lorsque ces éléments ont été produits lors du précédent dossier",
      "title": "EF définitifs déposés à l’administration fiscale avec cachet d’un cabinet d’audit et/ou visa CAC lorsque ces éléments ont été produits lors du précédent dossier"
    },
    {
      "key":  "funds_vs_social_capital",
      "desc": "FP > à 50% du capital social",
      "title": "FP > à 50% du capital social"
    },
    {
      "key":  "ebitda",
      "desc": "EBITDA > 0",
      "title": "EBITDA > 0"
    },
    {
      "key":  "net_income",
      "desc": "Si RN négatif, RN N-1 >0",
      "title": "Si RN négatif, RN N-1 >0"
    },
    {
      "key":  "gross_financial_debt",
      "desc": "Ratio Dette financière brute / EBITDA post transaction (définition BCE) < 4",
      "title": "Ratio Dette financière brute / EBITDA post transaction (définition BCE) < 4"
    },
    {
      "key":  "no_financial_covenants",
      "desc": "Pas de bris de covenants financiers depuis la mise en place des lignes (focus sur les covenants financiers)",
      "title": "Pas de bris de covenants financiers depuis la mise en place des lignes (focus sur les covenants financiers)"
    },
    {
      "key":  "all_last_guarantees_taken",
      "desc": "Prise effective de toutes les garanties sollicitées lors du dernier octroi (se référer à la fiche garanties)",
      "title": "Prise effective de toutes les garanties sollicitées lors du dernier octroi (se référer à la fiche garanties)"
    },
    {
      "key":  "authorization_in_cbs",
      "desc": "Saisie des autorisations dans le Core Banking System (ce qui suppose un respect des autres conditions d’octroi)",
      "title": "Saisie des autorisations dans le Core Banking System (ce qui suppose un respect des autres conditions d’octroi)"
    },
    {
      "key":  "average_monthly_flow_vs_overdraft",
      "desc": "Flux Moyens Mensuels sur 12 mois glissants > à l’autorisation de découvert (s’il y en a une) ",
      "title": "Flux Moyens Mensuels sur 12 mois glissants > à l’autorisation de découvert (s’il y en a une) "
    },
    {
      "key":  "no_overrun",
      "desc": "Absence de dépassement d’autorisation et/ou d’impayé en cours",
      "title": "Absence de dépassement d’autorisation et/ou d’impayé en cours"
    },
    {
      "key":  "no_line_changed",
      "desc": "Typologie de lignes inchangée sinon ajout de lignes mieux sécurisées",
      "title": "Typologie de lignes inchangée sinon ajout de lignes mieux sécurisées"
    },
    {
      "key":  "renew_line",
      "desc": "Renouvellement des lignes à l’identique, voire augmentation dans la limite de l’évolution du CA",
      "title": "Renouvellement des lignes à l’identique, voire augmentation dans la limite de l’évolution du CA"
    },
    {
      "key":  "no_cmt_demand",
      "desc": "Absence de demande de mise en place de CMT (hors enveloppe MT/CB)",
      "title": "Absence de demande de mise en place de CMT (hors enveloppe MT/CB)"
    },
    {
      "key":  "last_cmt_later_than_12month",
      "desc": "Dernier MT significatif  mis en place (hors enveloppe), en amortissement depuis plus de 12 mois.",
      "title": "Dernier MT significatif  mis en place (hors enveloppe), en amortissement depuis plus de 12 mois."
    }
  ]
