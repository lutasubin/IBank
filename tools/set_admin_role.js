
const admin = require('firebase-admin');

async function main() {
  const email = process.argv[2];
  if (!email) {
    console.error('Usage: node tools/set_admin_role.js <email>');
    process.exit(1);
  }

  // Yêu cầu đã set GOOGLE_APPLICATION_CREDENTIALS
  admin.initializeApp({
    credential: admin.credential.applicationDefault(),
  });

  try {
    const user = await admin.auth().getUserByEmail(email);
    await admin.auth().setCustomUserClaims(user.uid, { role: 'admin' });
    const updated = await admin.auth().getUser(user.uid);
    console.log(`Done. Claims for ${email}:`, updated.customClaims);
  } catch (e) {
    console.error('Failed:', e.message);
    process.exit(1);
  }
}

main();

