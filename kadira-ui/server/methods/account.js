KadiraAccounts = {};

KadiraAccounts.updateAppPlan = function(userId, newPlan, oldPlan) {
  var query = {owner: userId};
  var fields = {"plan": newPlan};

  //upgraded from free plan to paid.
  // move their paid apps to paid
  if(oldPlan === "free" && newPlan !== "free"){
    fields.pricingType = "paid";
  } else if (oldPlan !== "free" && newPlan === "free") {
    // user is moving to free plan from a paid plan.
    // move their paid apps to free
    fields.pricingType = "free";
  }

  return Apps.update(query, {$set: fields}, {multi: true});
};

KadiraAccounts._getMedianHostCount = function(hostUsageByTime, noDataCount) {
  hostUsageByTime = hostUsageByTime || [];
  if(hostUsageByTime.length === 0){
    return 0;
  }
  var values = _.chain(hostUsageByTime)
                  .pluck("count")
                  .sortBy(function(num) { return num})
                  .value();
  var missingDataArr = Array(noDataCount).fill(0);
  values = missingDataArr.concat(values);

  var half = Math.floor(values.length / 2);
  var median;
  if(values.length % 2) {
    median = values[half];
  } else {
    median = (values[half - 1] + values[half]) / 2
  }
  return Math.floor(median);
};
