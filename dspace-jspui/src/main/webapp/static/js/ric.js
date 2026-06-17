/**
 * DSpace Batch Input Helper
 * * Este script adiciona um recurso de importação/cópia em lote para campos repetíveis
 * que não possuem vocabulário controlado no formulário de submissão do DSpace.
 */

// 1. Inicialização segura dos Tooltips
jQuery(function ($) {
    // Correção: Verifica se de fato existem elementos com tooltip usando .length
    if ($('[data-toggle="tooltip"]').length > 0) {
        $('[data-toggle="tooltip"]').tooltip();
    }
});

// 2. Inicialização segura da lógica de colagem em lote
jQuery(document).ready(function ($) {
    
    // Procura todos os botões "Add" na página de submissão (indica que é um campo repetível)
    $("input[type='submit'][name$='_add'], button[name$='_add']").each(function () {
        var btnAdd = $(this);
        var btnName = btnAdd.attr('name');
        
        if (!btnName) return;

        // Extrai o nome do metadado. Ex: "submit_dc_identifier_registration_add" vira "dc_identifier_registration"
        var baseName = btnName.replace('submit_', '').replace('_add', '');

        // Detecta inputs cujo nome é exatamente `baseName` ou que seguem o padrão `baseName_N` (ex: baseName_1)
        function escapeRegExp(str) {
            return str.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
        }
        var nameRegex = new RegExp('^' + escapeRegExp(baseName) + '(?:_\\d+)?$');
        var groupInputs = $("input[type='text']").filter(function () {
            var n = $(this).attr('name') || '';
            return nameRegex.test(n);
        });
        var inputField = groupInputs.first();

        // Verifica se NÃO possui vocabulário controlado / autoridade (não existe botão _lookup)
        // Expandido para suportar tanto input quanto button para o lookup
        var isReadOnly = inputField.prop('readonly');

        // Se atende a todos os requisitos, injetamos a interface de cópia em lote
        if (inputField.length > 0 && !isReadOnly) {

            // Cria o botão que ficará ao lado do input com estilo alinhado ao Bootstrap do DSpace
            var btnBatch = $('<button type="button" class="btn btn-info btn-sm" style="margin-left: 15px; margin-top:5px; font-weight: 500;">Colar Múltiplos</button>');

            // Cria o container oculto com o textarea (com visual moderno e limpo)
            var divBatch = $('<div class="batch-container" style="display:none; margin-top: 5px;margin-left: 15px;padding: 15px; background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 8px; box-shadow: 0 1px 3px rgba(0,0,0,0.05);">' +
                '<p style="font-size: 13px; font-weight: 600; color: #334155; margin-bottom: 8px;">Cole os valores abaixo (um por linha):</p>' +
                '<textarea rows="5" class="form-control" style="width: 100%; margin-bottom: 12px; font-family: monospace; font-size: 13px; border-radius: 6px; border: 1px solid #cbd5e1; padding: 8px; resize: vertical;"></textarea>' +
                '<div style="display: flex; gap: 8px;">' +
                    '<button type="button" class="btn btn-success btn-sm btn-processar" style="font-weight: 500;">Adicionar Valores</button>' +
                    '<button type="button" class="btn btn-default btn-sm btn-cancelar" style="font-weight: 500; border: 1px solid #cbd5e1;">Cancelar</button>' +
                '</div>' +
                '</div>');

            // Painel de notificação customizado (substitui o alert nativo do navegador)
            var alertFeedback = $('<div class="batch-success-alert" style="display:none; margin-left: 15px; margin-top: 12px; padding: 12px 16px; border-radius: 6px; background-color: #ecfdf5; color: #065f46; border: 1px solid #a7f3d0; font-size: 13px; line-height: 1.5; font-family: inherit;">' +
                '<strong>✨ Sucesso!</strong> Campos gerados com sucesso abaixo.<br>' +
                'Não se esqueça de clicar em <strong>"Salvar"</strong> ou <strong>"Próximo"</strong> para gravar os dados definitivamente.' +
                '</div>');

            // Insere os elementos na tela logo após o botão "Add" padrão do DSpace
            btnAdd.after(btnBatch);
            btnBatch.after(divBatch);
            divBatch.after(alertFeedback);

            // Ação de abrir/fechar a caixa de texto
            btnBatch.click(function (e) {
                e.preventDefault();
                divBatch.slideToggle('fast');
            });

            // Ação de cancelar (limpa e fecha a caixa)
            divBatch.find('.btn-cancelar').click(function (e) {
                e.preventDefault();
                divBatch.slideUp('fast');
                divBatch.find('textarea').val('');
            });

            // Ação de processar os dados colados
            divBatch.find('.btn-processar').click(function (e) {
                e.preventDefault();
                var lines = divBatch.find('textarea').val().split('\n');
                var currentInput = inputField;
                var first = true;
                var addedCount = 0;

                // Calcula o próximo índice disponível com base nos inputs existentes (baseName => index 0)
                var existingIndices = [];
                groupInputs.each(function () {
                    var nm = $(this).attr('name') || '';
                    var m = nm.match(/_(\d+)$/);
                    existingIndices.push(m ? parseInt(m[1], 10) : 0);
                });
                var maxIndex = existingIndices.length ? Math.max.apply(null, existingIndices) : 0;
                var nextIndex = maxIndex + 1;

                for (var i = 0; i < lines.length; i++) {
                    var val = lines[i].trim();
                    if (val !== "") {
                        if (first) {
                            // Preenche a caixa original vazia do DSpace com o primeiro valor
                            currentInput.val(val);
                            first = false;
                            addedCount++;
                        } else {
                            // Clona o input, ajusta o `name` para o próximo índice disponível e adiciona
                            var clone = currentInput.clone(false);
                            clone.removeAttr('id');
                            var newName = baseName + '_' + nextIndex;
                            clone.attr('name', newName);
                            clone.val(val);
                            clone.css('margin-top', '6px');
                            currentInput.after(clone);
                            currentInput = clone; // O próximo clone ficará posicionado abaixo deste
                            nextIndex++;
                            addedCount++;
                        }
                    }
                }

                // Fecha o container de inserção e limpa a área de transferência
                divBatch.slideUp('fast');
                divBatch.find('textarea').val('');

                // Se houveram adições, mostra o alerta flutuante de sucesso
                if (addedCount > 0) {
                    alertFeedback.slideDown('fast').delay(6500).slideUp('fast');
                }
            });
        }
    });
});