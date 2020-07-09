package model

type SessionBody struct {
  Amount              float64        `json:"amount"`
  Antifraud           Antifraud     `json:"antifraud"`
  Channel             string        `json:"channel"`
  RecurrenceMaxAmount *float64       `json:"recurrenceMaxAmount"`
}

type Antifraud struct {
  ClientIP           string              `json:"clientIp"`
  MerchantDefineData  MerchantDefineData   `json:"merchantDefineData"`
}

type MerchantDefineData struct {
  Mdd4    string  `json:"MDD4"`
  Mdd32   string  `json:"MDD32"`
  Mdd75   string  `json:"MDD75"`
  Mdd77   int     `json:"MDD77"`
}