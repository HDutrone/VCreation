import React, { useState } from 'react';
import {
  View, Text, TextInput, TouchableOpacity, ScrollView,
  StyleSheet, KeyboardAvoidingView, Platform,
} from 'react-native';
import { NativeStackScreenProps } from '@react-navigation/native-stack';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '../../constants/Colors';
import { GoldButton } from '../../components/GoldButton';
import { useApp } from '../../context/AppContext';
import type { RootStackParamList } from '../../navigation/types';

type Props = NativeStackScreenProps<RootStackParamList, 'Register'>;

export default function RegisterScreen({ navigation }: Props) {
  const { register, state } = useApp();
  const [name, setName]     = useState('');
  const [email, setEmail]   = useState('');
  const [phone, setPhone]   = useState('');
  const [pwd, setPwd]       = useState('');
  const [obscure, setOb]    = useState(true);

  const handleRegister = async () => {
    if (!name || !email || !pwd) return;
    const ok = await register(name, email, pwd, phone);
    if (ok) navigation.replace('ClientApp', { initialTab: 0 });
  };

  const Field = ({ placeholder, value, onChangeText, icon, keyboardType = 'default', secureTextEntry = false, extra }: any) => (
    <View style={styles.inputWrap}>
      <Ionicons name={icon} size={18} color={Colors.textMuted} style={styles.icon} />
      <TextInput
        style={[styles.input, { flex: 1 }]}
        placeholder={placeholder} placeholderTextColor={Colors.textMuted}
        value={value} onChangeText={onChangeText}
        keyboardType={keyboardType} secureTextEntry={secureTextEntry}
        autoCapitalize={keyboardType === 'email-address' ? 'none' : 'words'}
      />
      {extra}
    </View>
  );

  return (
    <KeyboardAvoidingView style={{ flex: 1, backgroundColor: Colors.background }} behavior={Platform.OS === 'ios' ? 'padding' : undefined}>
      <ScrollView contentContainerStyle={styles.scroll} keyboardShouldPersistTaps="handled">
        <TouchableOpacity onPress={() => navigation.goBack()} style={styles.back}>
          <Ionicons name="arrow-back" size={22} color={Colors.white} />
        </TouchableOpacity>
        <Text style={styles.title}>Créer un profil</Text>
        <Text style={styles.sub}>Rejoignez la communauté V Créations</Text>
        <View style={{ height: 28 }} />

        <Field placeholder="Nom complet" value={name} onChangeText={setName} icon="person-outline" />
        <View style={{ height: 12 }} />
        <Field placeholder="Email" value={email} onChangeText={setEmail} icon="mail-outline" keyboardType="email-address" />
        <View style={{ height: 12 }} />
        <Field placeholder="Téléphone (optionnel)" value={phone} onChangeText={setPhone} icon="call-outline" keyboardType="phone-pad" />
        <View style={{ height: 12 }} />
        <View style={styles.inputWrap}>
          <Ionicons name="lock-closed-outline" size={18} color={Colors.textMuted} style={styles.icon} />
          <TextInput
            style={[styles.input, { flex: 1 }]} placeholder="Mot de passe" placeholderTextColor={Colors.textMuted}
            secureTextEntry={obscure} value={pwd} onChangeText={setPwd} autoCapitalize="none"
          />
          <TouchableOpacity onPress={() => setOb(v => !v)} style={{ paddingRight: 14 }}>
            <Ionicons name={obscure ? 'eye-off-outline' : 'eye-outline'} size={18} color={Colors.textMuted} />
          </TouchableOpacity>
        </View>

        {!!state.authError && <Text style={styles.error}>{state.authError}</Text>}
        <View style={{ height: 28 }} />
        <GoldButton label="Créer mon profil" onPress={handleRegister} loading={state.authLoading} />
        <View style={{ height: 40 }} />
      </ScrollView>
    </KeyboardAvoidingView>
  );
}

const styles = StyleSheet.create({
  scroll: { flexGrow: 1, padding: 28, paddingTop: 60 },
  back: { marginBottom: 24, width: 36 },
  title: { color: Colors.white, fontSize: 24, fontWeight: '700' },
  sub: { color: Colors.textSecondary, fontSize: 13, marginTop: 4 },
  inputWrap: {
    flexDirection: 'row', alignItems: 'center',
    backgroundColor: Colors.surface, borderRadius: 12,
    borderWidth: 1, borderColor: Colors.cardBorder,
  },
  icon: { paddingHorizontal: 14 },
  input: { color: Colors.white, fontSize: 14, paddingVertical: 14, paddingRight: 14 },
  error: { color: Colors.error, fontSize: 13, marginTop: 8 },
});
