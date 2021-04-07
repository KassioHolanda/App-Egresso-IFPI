import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';
part 'pessoa.g.dart';

class PessoaModel = _PessoaModelBase with _$PessoaModel;

abstract class _PessoaModelBase with Store {
  @observable
  String uid;
  @observable
  String cpf;
  @observable
  Timestamp dataNascimento;
  @observable
  Timestamp dataCadastro;
  @observable
  String email;
  @observable
  String nome;

  @action
  setCpf(String value) => cpf = value;
  @action
  setDataNascimento(Timestamp value) => dataNascimento = value;
  @action
  setDataCadastro(Timestamp value) => dataCadastro = value;
  @action
  setEmail(String value) => email = value;
  @action
  setNome(String value) => nome = value;

  _PessoaModelBase();

  _PessoaModelBase.fromDocument(DocumentSnapshot documentSnapshot) {
    uid = documentSnapshot.id;
    cpf = documentSnapshot.data()['cpf'];
    dataNascimento = documentSnapshot.data()['data_nascimento'];
    dataCadastro = documentSnapshot.data()['data_cadastro'];
    email = documentSnapshot.data()['email'];
    nome = documentSnapshot.data()['nome'];
  }

  Map<String, dynamic> toMap() {
    return {      
      // 'uid': uid,
      'cpf': cpf,
      'data_nascimento': dataNascimento,
      'data_cadastro': dataCadastro,
      'email': email,
      'nome': nome,
    };
  }
}
