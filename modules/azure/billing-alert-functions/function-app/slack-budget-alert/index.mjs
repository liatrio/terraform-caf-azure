import axios from "axios"

export default async function (context, req) {

    const alert = req.body;

     const body = {
        "blocks": [
            {
                "type": "header",
                "text": {
                    "type": "plain_text",
                    "text": ":exclamation: Azure Budget Alert"
                }
            },
            {
                "type": "section",
                "fields": [
                    {
                        "type": "mrkdwn",
                        "text": `*Budget Name:*\n${alert.data.BudgetName}`
                    },
                    {
                        "type": "mrkdwn",
                        "text": `*Subscription Name:*\n${alert.data.SubscriptionName}`
                    }
                ]
            },
            {
                "type": "section",
                "fields": [
                    {
                        "type": "mrkdwn",
                        "text": `*Budgeted Amount:*\n$${alert.data.Budget}`
                    },
                    {
                        "type": "mrkdwn",
                        "text": `*Alert Threshold:*\n$${alert.data.NotificationThresholdAmount}`
                    }
                ]
            }
        ]
    }

    //Sending to Slack via Webhook
    const result = await axios.post(process.env["slackWebhookUrl"], body);
    context.done();
};
