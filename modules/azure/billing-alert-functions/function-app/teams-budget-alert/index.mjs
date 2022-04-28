import axios from "axios"

export default async function (context, req) {

    const alert = req.body;

    const body = {
        "@type": "MessageCard",
        "@context": "http://schema.org/extensions",
        "themeColor": "89DF00",
        "summary": "Azure Budget Alert",
        "sections": [{
            "activityTitle": "Azure Budget Alert",
            "facts": [{
                "name": "Budget Name",
                "value": `${alert.data.BudgetName}`
            }, {
               "name": "Subscription",
               "value": `${alert.data.SubscriptionName}`
            }, {
                "name": "Budgeted Amount",
                "value": `${alert.data.Budget}`
            }, {
                "name": "Alert Threshold",
                "value": `${alert.data.NotificationThresholdAmount}`
            }],
            "markdown": true
        }],
    }

    //Sending to Slack via Webhook
    const result = await axios.post(process.env["teamsWebhookUrl"], body);
    context.done();
};
