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
  String email;
  @observable
  String nome;

  _PessoaModelBase.fromDocument(DocumentSnapshot documentSnapshot) {
    uid = documentSnapshot.id;
    cpf = documentSnapshot.data()['cpf'];
    dataNascimento = documentSnapshot.data()['dataNascimento'];
    email = documentSnapshot.data()['email'];
    nome = documentSnapshot.data()['nome'];
  }
}
