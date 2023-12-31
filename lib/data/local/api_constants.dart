class APIURLConstants {
  static const baseUrl =
      "https://staging.coins-chain.com"; // "https://tradexpro-laravel.cdibrandstudio.com";

  ///End Urls : POST
  static const signIn = "/api/sign-in";
  static const signUp = "/api/sign-up";
  static const verifyEmail = "/api/verify-email";
  static const g2FAVerify = "/api/g2f-verify";
  static const forgotPassword = "/api/forgot-password";
  static const resetPassword = "/api/reset-password";
  static const changePassword = "/api/change-password";
  static const logoutApp = "/api/log-out-app";
  static const walletNetworkAddress = "/api/get-wallet-network-address";
  static const walletWithdrawalProcess = "/api/wallet-withdrawal-process";
  static const swapCoinApp = "/api/swap-coin-app";
  static const updateProfile = "/api/update-profile";
  static const sendPhoneVerificationSms = "/api/send-phone-verification-sms";
  static const phoneVerify = "/api/phone-verify";
  static const google2faSetup = "/api/google2fa-setup";
  static const updateCurrency = "/api/update-currency";
  static const languageSetup = "/api/language-setup";
  static const uploadNID = "/api/upload-nid";
  static const uploadPassport = "/api/upload-passport";
  static const uploadDrivingLicence = "/api/upload-driving-licence";
  static const uploadVoterCard = "/api/upload-voter-card";
  static const notificationSeen = "/api/notification-seen";
  static const sellLimitApp = "/api/sell-limit-app";
  static const buyLimitApp = "/api/buy-limit-app";
  static const buyMarketApp = "/api/buy-market-app";
  static const sellMarketApp = "/api/sell-market-app";
  static const sellStopLimitApp = "/api/sell-stop-limit-app";
  static const buyStopLimitApp = "/api/buy-stop-limit-app";
  static const cancelOpenOrderApp = "/api/cancel-open-order-app";
  static const currencyDepositRate = "/api/get-currency-deposit-rate";
  static const currencyDepositProcess = "/api/currency-deposit-process";
  static const getFiatWithdrawalRate = "/api/get-fiat-withdrawal-rate";
  static const userBankSave = "/api/user-bank-save";
  static const userBankDelete = "/api/user-bank-delete";
  static const fiatWithdrawalProcess = "/api/fiat-withdrawal-process";
  static const thirdPartyKycVerified = "/api/third-party-kyc-verified";
  static const profileDeleteRequest = "/api/profile-delete-request";
  static const investmentCanceled = "/api/staking/investment-canceled";
  static const totalInvestmentBonus = "/api/staking/get-total-investment-bonus";
  static const investmentSubmit = "/api/staking/investment-submit";
  static const giftCardBuyCard = "/api/gift-card/buy-card";
  static const giftCardUpdateCard = "/api/gift-card/update-card";

  static const getTradeOptions = "/api/trade-options";
  static const userTrade = "/api/user-trade";
  static const userTradeResultSubmit = "/api/user-trade/result";
  static const userTradeHistory = "/api/user-trade/history";
  static const cryptoWallet = "/api/crypto-wallets";
  static const getMiningOptions = "/api/mining-options";
  static const userDoMining = "/api/user-mining";
  static const userCancelMining = "/api/user-mining/cancel";
  static const userMiningHistory = "/api/user-mining/history";
  static const withdrawRequirement = "/api/user/withdraw/requirement";
  static const userWithdrawRequest = '/api/user/withdraw/request';
  static const withdrawRequestHistory = '/api/user/withdraw/history';

  ///End Urls : GET
  static const getAppDashboard = "/api/app-dashboard/";
  static const getExchangeChartDataApp = "/api/get-exchange-chart-data-app";
  static const getExchangeAllOrdersApp = "/api/get-exchange-all-orders-app";
  static const getExchangeMarketTradesApp =
      "/api/get-exchange-market-trades-app";
  static const getMyAllOrdersApp = "/api/get-my-all-orders-app";
  static const getMyTradesApp = "/api/get-my-trades-app";
  static const getProfile = "/api/profile";
  static const getWalletList = "/api/wallet-list";
  static const getWalletDeposit = "/api/wallet-deposit-";
  static const getWalletWithdrawal = "/api/wallet-withdrawal-";
  static const getCommonSettings = "/api/common-settings";
  static const getCommonSettingsWithLanding =
      "/api/common-landing-custom-settings";
  static const getWalletHistoryApp = "/api/wallet-history-app";
  static const getCoinConvertHistoryApp = "/api/coin-convert-history-app";
  static const getAllBuyOrdersHistoryApp = "/api/all-buy-orders-history-app";
  static const getAllSellOrdersHistoryApp = "/api/all-sell-orders-history-app";
  static const getAllTransactionHistoryApp = "/api/all-transaction-history-app";
  static const getCurrencyDepositHistory = "/api/currency-deposit-history";
  static const getFiatWithdrawalHistory = "/api/fiat-withdrawal-history";
  static const getAllStopLimitOrdersApp = "/api/get-all-stop-limit-orders-app";
  static const getReferralHistory = "/api/referral-history";
  static const getRateApp = "/api/get-rate-app";
  static const getUserSetting = "/api/user-setting";
  static const getActivityList = "/api/activity-list";
  static const getKYCDetails = "/api/kyc-details";
  static const getUserKYCSettingsDetails = "/api/user-kyc-settings-details";
  static const getSetupGoogle2faLogin = "/api/setup-google2fa-login";
  static const getFaqList = "/api/faq-list";
  static const getNotifications = "/api/notifications";
  static const getReferralApp = "/api/referral-app";
  static const getCurrencyDeposit = "/api/currency-deposit";
  static const getFiatWithdrawal = "/api/fiat-withdrawal";
  static const getUserBankList = "/api/user-bank-list";
  static const getStakingOfferList = "/api/staking/offer-list";
  static const getStakingOfferDetails = "/api/staking/offer-list-details";
  static const getStakingInvestmentList = "/api/staking/investment-list";
  static const getStakingInvestmentStatistics =
      "/api/staking/investment-statistics";
  static const getStakingInvestmentPaymentList =
      "/api/staking/investment-get-payment-list";
  static const getStakingLandingDetails = "/api/staking/landing-details";
  static const getGiftCardMainPage = "/api/gift-card/gift-card-main-page";
  static const getGiftCardCheck = "/api/gift-card/check-card";
  static const getGiftCardRedeemCode = "/api/gift-card/get-redeem-code";
  static const getGiftCardThemeData = "/api/gift-card/gift-card-themes-page";
  static const getGiftCardThemes = "/api/gift-card/get-gift-card-themes";
  static const getGiftCardMyPageData = "/api/gift-card/my-gift-card-page";
  static const getGiftCardMyCardList = "/api/gift-card/my-gift-card-list";
  static const getGiftCardBuyData = "/api/gift-card/buy-card-page-data";
  static const getGiftCardWalletData = "/api/gift-card/gift-card-wallet-data";
  static const getGiftCardRedeem = "/api/gift-card/redeem-card";
  static const getGiftCardAdd = "/api/gift-card/add-gift-card";
  static const getGiftCardSend = "/api/gift-card/send-gift-card";
}

class APIKeyConstants {
  static const firstName = "first_name";
  static const lastName = "last_name";
  static const nickName = "nickname";
  static const email = "email";
  static const password = "password";
  static const confirmPassword = "password_confirmation";
  static const oldPassword = "old_password";
  static const accessToken = "access_token";
  static const accessType = "access_type";
  static const userId = "user_id";
  static const user = "user";
  static const refreshToken = "refreshToken";
  static const gRecaptchaResponse = "g-recaptcha-response";
  static const recaptcha = "recapcha";
  static const score = "score";
  static const expireAt = "expireAt";
  static const phone = "phone";
  static const name = "name";
  static const title = "title";
  static const status = "status";
  static const image = "image";
  static const id = "id";
  static const ids = "ids";
  static const updatedAt = "updated_at";
  static const createdAt = "created_at";
  static const avatar = "avatar";
  static const isEmailVerified = "isEmailVerified";
  static const walletAddress = "walletAddress";
  static const first = "first";
  static const paginateNumber = "paginateNumber";
  static const currentPassword = "current_password";
  static const country = "country";
  static const gender = "gender";
  static const photo = "photo";
  static const verificationType = "verification_type";
  static const frontImage = "front_image";
  static const backImage = "back_image";
  static const fileTwo = "file_two";
  static const fileThree = "file_three";
  static const fileSelfie = "file_selfie";
  static const accept = "Accept";
  static const authorization = "Authorization";
  static const page = "page";
  static const perPage = "per_page";
  static const limit = "limit";
  static const type = "type";
  static const language = "language";
  static const verifyCode = "verify_code";
  static const code = "code";
  static const token = "token";
  static const url = "url";
  static const remove = "remove";
  static const google2factSecret = "google2fa_secret";
  static const g2fEnabled = "g2f_enabled";
  static const userApiSecret = "userapisecret";
  static const userAgent = "User-Agent";
  static const lang = "lang";
  static const dashboardType = "dashboard_type";
  static const orderType = "order_type";
  static const baseCoinId = "base_coin_id";
  static const tradeCoinId = "trade_coin_id";
  static const orders = "orders";
  static const transactions = "transactions";
  static const wallets = "wallets";
  static const wallet = "wallet";
  static const walletType = "wallet_type";
  static const address = "address";
  static const amount = "amount";
  static const currency = "currency";
  static const price = "price";
  static const stop = "stop";
  static const total = "total";
  static const columnName = "column_name";
  static const orderBy = "order_by";
  static const success = "success";
  static const message = "message";
  static const emailVerified = "email_verified";
  static const time = "time";
  static const data = "data";
  static const walletId = "wallet_id";
  static const fromWalletId = "from_wallet_id";
  static const paymentMethodId = "payment_method_id";
  static const bankId = "bank_id";
  static const bankReceipt = "bank_receipt";
  static const networkType = "network_type";
  static const fromCoinId = "from_coin_id";
  static const toCoinId = "to_coin_id";
  static const convertRate = "convert_rate";
  static const rate = "rate";
  static const note = "note";
  static const setup = "setup";
  static const google2faSecret = "google2fa_secret";
  static const faqTypeId = "faq_type_id";
  static const calculatedAmount = "calculated_amount";
  static const stripeToken = "stripe_token";
  static const paypalToken = "paypal_token";
  static const interval = "interval";
  static const activityLog = "activityLog";
  static const inquiryId = "inquiry_id";
  static const deleteRequestReason = "delete_request_reason";
  static const uid = "uid";
  static const autoRenewStatus = "auto_renew_status";
  static const totalBonus = "total_bonus";
  static const commonSettings = "common_settings";
  static const card = "card";
  static const banner = "banner";
  static const bannerId = "banner_id";
  static const cardUid = "card_uid";
  static const redeemCode = "redeem_code";
  static const coinType = "coin_type";
  static const lock = "lock";
  static const bulk = "bulk";
  static const quantity = "quantity";
  static const from = "from";
  static const sendBy = "send_by";
  static const toEmail = "to_email";
  static const toPhone = "to_phone";

  static const vAccept = "application/json";
  static const vProfilePhotoPath = "";
  static const vBearer = "Bearer";
  static const vOrderDESC = "desc";
  static const vOrderASC = "asc";

  static const tradeType = "trade_type";
  static const tradeOptionID = "trade_option_id";
  static const tradeAmount = "trade_amount";
  static const startingPrice = "starting_price";
  static const duration = "duration";
  static const coin = "coin";
  static const uuid = "uuid";
  static const currentPrice = "current_price";
  static const tradeOptionDuration = "trade_option_duration";
  static const tradeOptionDurationForshow = "trade_option_duration_forshow";
  static const remark = "remark";
  static const tradeHandlingFee = "trade_handling_fee";
  static const miningOptionID = "mining_option_id";
  static const investmentAmount = "investment_amount";
  static const period = "period";
  static const dailyReturnPercent = "daily_return_percent";
  static const passowrd = "password";
  static const withdrawHandlingFee = "handling_fee";
}

class SocketConstants {
  static const baseUrl = "wss://tradexpro-laravel.cdibrandstudio.com/app/test";
//"wss://admin.coins-chain.com"; //
  static const channelNotification = "notification_";
  static const channelDashboard = "dashboard-";
  static const channelTradeInfo = "trade-info-";
  static const channelTradeHistory = "trade-history-";
  static const channelOrderPlace = "order_place_";

  static const eventNotification = "notification";
  static const eventOrderPlace = "order_place";
  static const eventProcess = "process";
  static const eventOrderRemove = "order_removed";
}

class URLConstants {
  static const website =
      "https://admin.coins-chain.com"; //"https://tradexpro-exchange.cdibrandstudio.com";
  static const referralLink = "$website/signup?";
  static const fbReferral = "https://www.facebook.com/sharer/sharer.php?u=";
  static const twitterReferral = "https://www.twitter.com/share?url=";
}

class ErrorConstants {
  static const unauthorized = "Unauthorized";
}
