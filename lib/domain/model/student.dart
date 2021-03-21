import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';
part 'student.g.dart';

class StudentModel = _StudentModelBase with _$StudentModel;

abstract class _StudentModelBase with Store {
  @observable
  String pessoaUid;
  @observable
  String nome;
  @observable
  String email;
  @observable
  Timestamp dataNascimento;
  @observable
  Timestamp dataCadastro;
  @observable
  String cpf;
  @observable
  String matricula;
  @observable
  String status;
  @observable
  String cursoUid;

  @action
  setMatricula(String value) => matricula = value;

  @action
  setDataNascimento(Timestamp value) => dataNascimento = value;

  @action
  setNome(String value) => nome = value;

  @action
  setEmail(String value) => email = value;

  @action
  setCourse(String value) => cursoUid = value;

  @action
  setState(String value) => status = value;

  @action
  setCPF(String value) => cpf = value;

  _StudentModelBase();

  _StudentModelBase.fromDocument(DocumentSnapshot document) {
    pessoaUid = document.data()['pessoa_uid'];
    cursoUid = document.data()['curso_uid'];
    nome = document.data()['nome'];
    email = document.data()['email'];
    dataNascimento = document.data()['data_nascimento'];
    dataCadastro = document.data()['data_cadastro'];
    cpf = document.data()['cpf'];
    matricula = document.data()['matricula'];
    status = document.data()['status'];
  }

  Map<String, dynamic> toMap() {
    return {
      'pessoaUid': pessoaUid,
      'cursoUid': cursoUid,
      'nome': nome,
      'email': email,
      'dataNascimento': dataNascimento,
      'dataCadastro': dataCadastro,
      'cpf': cpf,
      'matricula': matricula,
      'status': status,
    };
  }
}
