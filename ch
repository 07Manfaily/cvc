import React, { useState, useEffect } from "react";
import FormWizard from "react-form-wizard-component";
import "react-form-wizard-component/dist/style.css";
import EligibilityCheck from "./eligibilityCheck";
import Engagement from "./engagementTable";
import BeforeRequest from "./descriptifBeforeRequest";
import AfterRequest from "./descriptifAfterRequest";
import { handleSendEngagement } from "./engagementTable";
import { handleSendInsight} from "./descriptifAfterRequest"

export default function Credapp() {
  const handleComplete = () => {
    // handleSendControl()
    console.log("Form completed!");
    // Handle form completion logic here
  };
 

 
  return (
    <>
  
      <FormWizard
        color="#A01D00"
        stepSize="sm"
        onComplete={handleComplete}
        nextButtonText="Suivant"
        backButtonText="Retour"
        finishButtonText="Terminer"
      >
        <FormWizard.TabContent title="Controle d'Eligibilité">
          <EligibilityCheck />
        </FormWizard.TabContent>
        <FormWizard.TabContent title="Descriptifs avant la demande">
          <BeforeRequest />
        </FormWizard.TabContent>
        <FormWizard.TabContent title="Descriptifs après la demande">
          <AfterRequest />
        </FormWizard.TabContent>
        <FormWizard.TabContent title="Details des nouvelles autorisations">
          <Engagement />
        </FormWizard.TabContent>
      </FormWizard>
    </>
  );
}
