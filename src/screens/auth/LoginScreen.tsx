import React, { useState } from 'react';
import {
  View, Text, TextInput, TouchableOpacity, ScrollView,
  StyleSheet, KeyboardAvoidingView, Platform, Alert,
} from 'react-native';
import { NativeStackScreenProps } from '@react-navigation/native-stack';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '../../constants/Colors';
import { Logo } from '../../components/Logo';
import { GoldButton } from '../../components/GoldButton';
import { GoldDivider } from '../../components/GoldDivider';
import { useApp } from '../../context/AppContext';
import type { RootStackParamList } from '../../navigation/types';

type Props = NativeStackScreenProps<RootStackParamList, 'Login'>;

const DEMOS = [
  { role: 'Client', email: 'amina@vcreations.cd', pwd: 'client123' },
  { role: 'Admin',  email: 'admin@vcreations.cd', pwd: 'admin123'  },
];

export default function LoginScreen({ navigation }: Props) {
  const { login, state } = useApp();
  const [email, setEmail]       = useState('');
  const [pwd, setPwd]           = useState('');
  const [obscure, setObscure]   = useState(true);

  const handleLogin = async () => {
    if (!email || !pwd) { Alert.alert('Champs requis', 'Email et mot de passe obligatoires.'); return; }
    const ok = await login(email.trim(), pwd);
    if (ok) {
      const isAdmin = email.trim().toLowerCase() === 'admin@vcreations.cd';
      if (isAdmin) {
        navigation.replace('AdminApp');
      } else {
        navigation.replace('ClientApp', { initialTab: 0 });
      }
    }
  };

  return (
    <KeyboardAvoidingView style={styles.flex} behavior={Platform.OS === 'ios' ? 'padding' : undefined}>
      <ScrollView contentContainerStyle={styles.scroll} keyboardShouldPersistTaps="handled">
        <Logo size={90} />
        <View style={{ height: 36 }} />
        <GoldDivider />
        <View style={{ height: 32 }} />

        <Text style={styles.title}>Connexion</Text>
        <Text style={styles.sub}>Accédez à votre espace client privé</Text>
        <View style={{ height: 28 }} />

        {/* Email */}
        <View style={styles.inputWrap}>
          <Ionicons name="mail-outline" size={18} color={Colors.textMuted} style={styles.inputIcon} />
          <TextInput
            style={styles.input} placeholder="Email" placeholderTextColor={Colors.textMuted}
            keyboardType="email-address" autoCapitalize="none"
            value={email} onChangeText={setEmail}
          />
        </View>
        <View style={{ height: 12 }} />

        {/* Password */}
        <View style={styles.inputWrap}>
          <Ionicons name="lock-closed-outline" size={18} color={Colors.textMuted} style={styles.inputIcon} />
          <TextInput
            style={[styles.input, { flex: 1 }]} placeholder="Mot de passe" placeholderTextColor={Colors.textMuted}
            secureTextEntry={obscure} value={pwd} onChangeText={setPwd}
          />
          <TouchableOpacity onPress={() => setObscure(v => !v)} style={{ paddingRight: 14 }}>
            <Ionicons name={obscure ? 'eye-off-outline' : 'eye-outline'} size={18} color={Colors.textMuted} />
          </TouchableOpacity>
        </View>

        {!!state.authError && (
          <View style={styles.errorBox}>
            <Ionicons name="alert-circle-outline" size={16} color={Colors.error} />
            <Text style={styles.errorText}>{state.authError}</Text>
          </View>
        )}
        <View style={{ height: 28 }} />

        <GoldButton label="Se connecter" onPress={handleLogin} loading={state.authLoading} />
        <View style={{ height: 16 }} />

        <TouchableOpacity onPress={() => navigation.navigate('Register')}>
          <Text style={styles.link}>Pas encore de compte ? Créer un profil</Text>
        </TouchableOpacity>
        <TouchableOpacity onPress={() => navigation.replace('ClientApp', { initialTab: 0 })} style={{ marginTop: 8 }}>
          <Text style={[styles.link, { color: Colors.textMuted, fontSize: 12 }]}>Continuer sans compte →</Text>
        </TouchableOpacity>

        {/* Demo accounts */}
        <View style={styles.demoBox}>
          <Text style={styles.demoTitle}>COMPTES DE DÉMONSTRATION</Text>
          {DEMOS.map(d => (
            <TouchableOpacity key={d.role} style={styles.demoRow}
              onPress={() => { setEmail(d.email); setPwd(d.pwd); }}>
              <View style={styles.roleBadge}><Text style={styles.roleText}>{d.role}</Text></View>
              <Text style={styles.demoEmail}>{d.email}</Text>
              <Text style={styles.demoPwd}>{d.pwd}</Text>
            </TouchableOpacity>
          ))}
        </View>
        <View style={{ height: 40 }} />
      </ScrollView>
    </KeyboardAvoidingView>
  );
}

const styles = StyleSheet.create({
  flex: { flex: 1, backgroundColor: Colors.background },
  scroll: { flexGrow: 1, padding: 28, alignItems: 'center', paddingTop: 60 },
  title: { color: Colors.white, fontSize: 24, fontWeight: '700', alignSelf: 'flex-start' },
  sub:   { color: Colors.textSecondary, fontSize: 13, marginTop: 4, alignSelf: 'flex-start' },
  inputWrap: {
    flexDirection: 'row', alignItems: 'center',
    backgroundColor: Colors.surface, borderRadius: 12,
    borderWidth: 1, borderColor: Colors.cardBorder, width: '100%',
  },
  inputIcon: { paddingHorizontal: 14 },
  input: {
    flex: 1, color: Colors.white, fontSize: 14,
    paddingVertical: 14, paddingRight: 14,
  },
  errorBox: {
    flexDirection: 'row', alignItems: 'center', gap: 8,
    backgroundColor: Colors.error + '1A', borderWidth: 1, borderColor: Colors.error + '4D',
    borderRadius: 8, padding: 12, width: '100%', marginTop: 12,
  },
  errorText: { color: Colors.error, fontSize: 13, flex: 1 },
  link: { color: Colors.gold, fontSize: 13, textAlign: 'center' },
  demoBox: {
    backgroundColor: Colors.surface, borderRadius: 10,
    borderWidth: 1, borderColor: Colors.cardBorder,
    padding: 14, width: '100%', marginTop: 32,
  },
  demoTitle: { color: Colors.textMuted, fontSize: 10, letterSpacing: 2, marginBottom: 10 },
  demoRow: { flexDirection: 'row', alignItems: 'center', marginBottom: 8, gap: 8 },
  roleBadge: {
    backgroundColor: Colors.goldFaint, borderRadius: 4,
    paddingHorizontal: 8, paddingVertical: 3,
  },
  roleText: { color: Colors.gold, fontSize: 11 },
  demoEmail: { color: Colors.textSecondary, fontSize: 12, flex: 1 },
  demoPwd: { color: Colors.textMuted, fontSize: 12 },
});
