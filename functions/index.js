const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.notifyAdminsOnNewOrder = functions.firestore
  .document("Orders/{orderId}")
  .onCreate(async (snap, context) => {
    const order = snap.data() || {};

    // Fetch admin users who have an FCM token saved.
    const adminsSnap = await admin
      .firestore()
      .collection("users")
      .where("isAdmin", "==", true)
      .get();

    const tokens = [];
    adminsSnap.forEach((doc) => {
      const t = doc.get("fcmToken");
      if (typeof t === "string" && t.length > 0) tokens.push(t);
    });

    if (tokens.length === 0) return null;

    const title = "New order";
    const bodyParts = [];
    if (order.customerName) bodyParts.push(order.customerName);
    if (order.totalPrice != null) bodyParts.push(`${order.totalPrice} EGP`);
    const body = bodyParts.join(" • ") || "A new order was placed";

    const message = {
      notification: { title, body },
      data: {
        orderId: context.params.orderId,
        status: String(order.status || "Pending")
      },
      tokens
    };

    const res = await admin.messaging().sendEachForMulticast(message);

    // Optionally clean up invalid tokens.
    // (Keeping simple; you can expand this later.)
    return res;
  });

async function getUserTokens({ adminOnly = false } = {}) {
  const query = admin
    .firestore()
    .collection("users")
    .where("isAdmin", "==", adminOnly);

  const snap = await query.get();
  const tokens = [];
  snap.forEach((doc) => {
    const t = doc.get("fcmToken");
    if (typeof t === "string" && t.length > 0) tokens.push(t);
  });
  return tokens;
}

exports.notifyUsersOnNewProduct = functions.firestore
  .document("products/{productId}")
  .onCreate(async (snap, context) => {
    const product = snap.data() || {};

    const tokens = await getUserTokens({ adminOnly: false });
    if (tokens.length === 0) return null;

    const title = "New product";
    const body = product.name ? String(product.name) : "A new product was added";

    return admin.messaging().sendEachForMulticast({
      notification: { title, body },
      data: {
        type: "product",
        productId: context.params.productId,
      },
      tokens,
    });
  });

exports.notifyUsersOnNewBanner = functions.firestore
  .document("banners/{bannerId}")
  .onCreate(async (snap, context) => {
    const tokens = await getUserTokens({ adminOnly: false });
    if (tokens.length === 0) return null;

    const title = "New banner";
    const body = "Check out the latest offer";

    return admin.messaging().sendEachForMulticast({
      notification: { title, body },
      data: {
        type: "banner",
        bannerId: context.params.bannerId,
      },
      tokens,
    });
  });

